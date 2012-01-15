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
    load JSON.parse(api[id].get(:accept => 'application/json'))
  end
  
  def load(hash)
    new(hash).tap do |instance|
      instance.changed_attributes.clear
    end
  end
  
  def all(type = :all)
    case type
      when :all then JSON.parse api.get(:accept => 'application/json')
      when :public then JSON.parse api['public'].get(:accept => 'application/json')
      when :starred then JSON.parse api['starred'].get(:accept => 'application/json')
      else raise ArgumentError, "Unknown type: #{type.inspect} (expected one of [:all, :public, :starred])"
    end.collect do |hash|
      load hash
    end
  end
end
