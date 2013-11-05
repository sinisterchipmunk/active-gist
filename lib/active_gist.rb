require 'active_model'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext'
require 'json'

class ActiveGist
  autoload :Version,      "active_gist/version"
  autoload :VERSION,      "active_gist/version"
  autoload :API,          "active_gist/api"
  autoload :Attributes,   "active_gist/attributes"
  autoload :ClassMethods, "active_gist/class_methods"
  autoload :Errors,       "active_gist/errors/invalid"
  autoload :Files,        "active_gist/files"
  
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Dirty
  include ActiveModel::Conversion
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml
  
  include ActiveGist::API
  include ActiveGist::Attributes
  extend ActiveGist::API
  extend ActiveGist::ClassMethods
  
  define_model_callbacks :save, :create, :update, :initialize, :validation
  validate { |record| record.errors.add(:files, "can't be blank") if record.files.empty? }
  
  alias _changed? changed? #:nodoc:
  def changed?
    _changed? || files.changed?
  end
  
  def initialize(attributes = {})
    run_callbacks :initialize do
      self.attributes = attributes
    end
  end
  
  def inspect
    "#<#{self.class.name} #{attributes.collect { |a| [a[0], a[1].inspect].join('=') }.join(' ')}>"
  end
  
  def persisted?
    !destroyed? && !id.blank? && !changed?
  end
  
  def new_record?
    !destroyed? && id.blank?
  end
  
  def destroyed?
    !!@destroyed
  end
  
  def destroy
    api[id].delete :accept => 'application/json'
    @id = nil
    @destroyed = true
  end
  
  def fork
    self.class.load(JSON.parse api[id]['fork'].post("", :accept => 'application/json'))
  end
  
  def files=(hash)
    files.replace_with hash.with_indifferent_access
  end
  
  def files
    @files ||= ActiveGist::Files.new
  end
  
  def ==(other)
    other.kind_of?(ActiveGist) && id == other.id
  end
  
  def save
    valid = begin
      run_callbacks :validation do
        valid?
      end
    end
    
    return false unless valid
    
    create_or_update_callback = new_record? ? :create : :update
    run_callbacks create_or_update_callback do
      run_callbacks :save do
        if new_record?
          data = as_json(:only => [:description, :public, :files]).to_json
          response = api.post data, :content_type => 'application/json', :accept => 'application/json'
        else
          data = as_json(:only => [:description, :files]).to_json
          response = api[id].patch data, :content_type => 'application/json', :accept => 'application/json'
        end
        self.attributes = JSON.parse response
        @previously_changed = changes
        changed_attributes.clear
      end
    end

    true
  end
  
  def save!
    raise ActiveGist::Errors::Invalid, "Gist is invalid: #{errors.full_messages.join('; ')}" unless save
  end

  def starred?
    if @star.nil?
      @star = begin
        @star = api[id]['star'].get :accept => 'application/json'
        true
      rescue RestClient::ResourceNotFound
        false
      end
    else
      @star
    end
  end
  
  def star!
    api[id]['star'].put("", :accept => 'application/json')
    @star = true
  end
  
  def unstar!
    api[id]['star'].delete(:accept => 'application/json')
    @star = false
  end
end
