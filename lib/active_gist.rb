require 'active_model'
require 'active_support/hash_with_indifferent_access'
require 'json'

class ActiveGist
  autoload :Version,      "active_gist/version"
  autoload :VERSION,      "active_gist/version"
  autoload :API,          "active_gist/api"
  autoload :Attributes,   "active_gist/attributes"
  autoload :ClassMethods, "active_gist/class_methods"
  autoload :Invalid,      "active_gist/errors/invalid"
  
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
  
  def persisted?
    !id.blank?
  end
  
  define_model_callbacks :save, :create, :update, :initialize, :validation
  validates_presence_of :files
  
  def initialize(attributes = {})
    run_callbacks :initialize do
      self.attributes = attributes
    end
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
    
    create_or_update_callback = persisted? ? :create : :update
    run_callbacks create_or_update_callback do
      run_callbacks :save do
        response = api.post to_json(:only => [:description, :public, :files]), :content_type => 'application/json'
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
