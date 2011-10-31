require 'mini_fb_rails/action_controller/methods'
require 'mini_fb_rails/action_controller/filters'
require 'mini_fb_rails/action_controller/responses'


module MiniFbRails
  
  module ActionController
  end

end

class ActionController::Base
  include MiniFbRails::ActionController::Methods
  include MiniFbRails::ActionController::Responses
  include MiniFbRails::ActionController::Filters
end