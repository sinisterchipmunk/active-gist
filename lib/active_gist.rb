require 'active_model'
require 'active_support/hash_with_indifferent_access'
require 'json'

class ActiveGist
  autoload :Version,      "active_gist/version"
  autoload :VERSION,      "active_gist/version"
  autoload :API,          "active_gist/api"
  autoload :Attributes,   "active_gist/attributes"
  autoload :ClassMethods, "active_gist/class_methods"
  
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
    false
  end
  
  validates_presence_of :files
  
  def initialize(attributes = {})
    self.attributes = attributes
  end
  
  def ==(other)
    id == other.id
  end
  
  def save
    response = api.post to_json(:only => [:description, :public, :files]), :content_type => 'application/json'
    self.attributes = JSON.parse response
    
    @previously_changed = changes
    changed_attributes.clear
  end
  
  def save!
    save
  end
end
