require 'active_model'

class ActiveGist
  autoload :Version, "active_gist/version"
  autoload :VERSION, "active_gist/version"
  
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Dirty
  include ActiveModel::Conversion
  
  def persisted?
    false
  end
end
