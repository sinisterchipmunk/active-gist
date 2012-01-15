module ActiveGist::ClassMethods
  def create!(options = {})
    new(options).tap { |gist| gist.save! }
  end
  
  def create(options = {})
    new(options).tap { |gist| gist.save }
  end
  
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
