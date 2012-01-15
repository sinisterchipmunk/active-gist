module ActiveGist::Attributes
  GIST_ATTRIBUTES = %w(url id description public user files comments
                       html_url git_pull_url git_push_url created_at
                       forks history updated_at)
                       
  def self.included(base) #:nodoc:
    base.define_attribute_methods GIST_ATTRIBUTES
  end
  
  def forks
    @forks
  end
  
  def history
    @history
  end
  
  def url
    @url
  end
  
  def id
    @id
  end
  
  def description
    @description
  end
  
  def public?
    !!@public
  end
  alias public public?
  
  def user
    @user
  end
  
  def files
    @files
  end
  
  def comments
    @comments
  end
  
  def html_url
    @html_url
  end
  
  def git_pull_url
    @git_pull_url
  end
  
  def git_push_url
    @git_push_url
  end
  
  def created_at
    @created_at
  end
  
  def updated_at
    @updated_at
  end
  
  def description=(descr)
    description_will_change!
    @description = descr
  end
  
  def public=(pub)
    public_will_change!
    @public = pub
  end
  
  def files=(files)
    files_will_change!
    @files = files
  end
  
  def attributes
    GIST_ATTRIBUTES.inject({}) { |h,k| h[k] = self[k]; h }
  end
  
  def attributes=(attributes)
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

  def [](attribute)
    send attribute.to_sym
  end
  
  def []=(attribute, value)
    send :"#{attribute}=", value
  end
end
