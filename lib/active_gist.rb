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
  autoload :Invalid,      "active_gist/errors/invalid"
  autoload :Files,        "active_gist/files"
  
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Dirty
  include ActiveModel::Conversion
  include ActiveModel::Serializers::JSON
  
  include ActiveGist::API
  include ActiveGist::Attributes
  extend ActiveGist::API
  extend ActiveGist::ClassMethods
  
  def starred?
    if @star.nil?
      @star = begin
        @star = api[id]['star'].get
        true
      rescue RestClient::ResourceNotFound
        false
      end
    else
      @star
    end
  end
  
  def star!
    api[id]['star'].put({})
    @star = true
  end
  
  def unstar!
    api[id]['star'].delete
    @star = false
  end
  
  def persisted?
    !id.blank? && !changed?
  end
  
  def new_record?
    id.blank?
  end
  
  alias _changed? changed? #:nodoc:
  def changed?
    _changed? || files.changed?
  end
  
  define_model_callbacks :save, :create, :update, :initialize, :validation
  validate { |record| record.errors.add(:files, "can't be blank") if record.files.empty? }
  
  def initialize(attributes = {})
    run_callbacks :initialize do
      self.attributes = attributes
    end
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
          response = api.post to_json(:only => [:description, :public, :files]), :content_type => 'application/json'
        else
          response = api[id].patch to_json(:only => [:description, :files]), :content_type => 'application/json'
        end
        self.attributes = JSON.parse response
        @previously_changed = changes
        changed_attributes.clear
      end
    end

    true
  end
  
  def save!
    raise ActiveGist::Invalid, "Gist is invalid: #{errors.full_messages.join('; ')}" unless save
  end
end
