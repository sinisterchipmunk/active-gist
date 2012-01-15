require 'active_model'
require 'active_support/hash_with_indifferent_access'
require 'json'

class ActiveGist
  autoload :Version,    "active_gist/version"
  autoload :VERSION,    "active_gist/version"
  autoload :API,        "active_gist/api"
  autoload :Attributes, "active_gist/attributes"
  
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Dirty
  include ActiveModel::Conversion
  
  include ActiveGist::API
  extend ActiveGist::API
  include ActiveGist::Attributes
  
  def persisted?
    false
  end
  
  def initialize(attributes = {})
    attributes.each do |key, value|
      if respond_to?(:"#{key}=")
        send :"#{key}=", value
      else
        if GIST_ATTRIBUTES.include?(key.to_s)
          instance_variable_set :"@#{key}", value
        else
          raise ArgumentError, "Unknown attribute #{key.inspect}; expected one of #{GIST_ATTRIBUTES.inspect}"
        end
      end
    end
  end
  
  def ==(other)
    id == other.id
  end
  
  def as_json(*options)
    attributes.as_json(*options)
  end
  
  def to_json(*options)
    attributes.to_json(*options)
  end
  
  class << self
    def first(type = :all)
      all(type).first
    end
    
    def last(type = :all)
      all(type).last
    end
    
    def count(type = :all)
      all(type).count
    end
    
    def find(id)
      instantiate_from_attributes JSON.parse(api[id].get)
    end
    
    def instantiate_from_attributes(hash)
      new(hash).tap do |instance|
        instance.changed_attributes.clear
      end
    end
    
    def all(type = :all)
      case type
        when :all then JSON.parse api.get
        when :public then JSON.parse api['public'].get
        when :starred then JSON.parse api['starred'].get
        else raise ArgumentError, "Unknown type: #{type.inspect} (expected one of [:all, :public, :starred])"
      end.collect do |hash|
        instantiate_from_attributes hash
      end
    end
  end
end
