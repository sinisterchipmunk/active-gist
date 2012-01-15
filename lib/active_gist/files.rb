class ActiveGist::Files
  delegate :key?, :has_key?, :[], :[]=, :empty?, :as_json, :to_json, :as_xml, :to_xml, :inspect, :to => :hash
  
  def initialize(hash = {})
    @hash = hash
    @changed = false
  end
  
  def changed?
    @hash_copy != hash
  end
  
  def replace_with(hash)
    return hash if hash == @hash
    @changed = true
    @hash_copy = deep_dup hash
    @hash = hash
  end
  
  private
  def hash
    @hash
  end
  
  def deep_dup(obj)
    if obj.kind_of?(Array)
      obj.collect { |a| deep_dup a }
    elsif obj.kind_of?(Hash)
      obj.inject(HashWithIndifferentAccess.new) { |h,(k,v)| h[deep_dup(k)] = deep_dup(v); h }
    elsif obj.respond_to?(:dup)
      begin
        obj.dup
      rescue TypeError
        obj
      end
    else
      obj
    end
  end
end
