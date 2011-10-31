module MiniFbRails::ActionController

  module Responses

    protected
    
    def render_invalid_request
      render_unauthorized "Invalid Facebook Request"
    end
    
    def render_invalid_signature
      render_unauthorized "Incorrect Signature"
    end
    
    private
    
    def render_unauthorized(text) # :nodoc:
      render(:text => text, :status => :unauthorized)
    end
    
  end
  
end
