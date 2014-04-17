module ActiveGist::Attributes
  GIST_ATTRIBUTES = %w(url id description public owner files comments
                       html_url git_pull_url git_push_url created_at
                       forks forks_url history updated_at comments_url commits_url)

  def self.included(base) #:nodoc:
    base.define_attribute_methods GIST_ATTRIBUTES
  end

  attr_reader :url,
              :id,
              :description,
              :owner,
              :files,
              :comments,
              :comments_url,
              :created_at,
              :forks,
              :forks_url,
              :history,
              :updated_at,
              :html_url,
              :git_pull_url,
              :git_push_url,
              :commits_url

  def public?
    !!@public
  end
  alias public public?

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
