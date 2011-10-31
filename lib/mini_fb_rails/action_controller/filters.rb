module MiniFbRails::ActionController

  module Filters

    protected
    
    
    def ensure_facebook_session
      ensure_facebook_session_is_present == true && ensure_facebook_cookie_signature_is_valid == true
    end
    
    def ensure_valid_facebook_signed_request
      ensure_facebook_signed_request == true && parse_signed_request
    end

    private

    def ensure_facebook_session_is_present # :nodoc:
      facebook_session? || redirect_to(no_facebook_session_url)
    end
    
    def ensure_facebook_cookie_signature_is_valid # :nodoc:
      facebook_session? && verify_cookie_signature || render_invalid_signature
    end
    
    def ensure_facebook_signed_request # :nodoc:
      signed_request? && valid_signed_request? || render_invalid_request
    end
   
  end
  
  
end