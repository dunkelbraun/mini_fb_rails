module MiniFbRails::ActionController
  
  module Methods
    
    def facebook_session
      @mini_fb_rails_facebook_session ||= parse_fb_cookies
    end

    def no_facebook_session_url # :nodoc:
      root_url
    end

    private
    
    def signed_request? # :nodoc:
      params['signed_request'].present?
    end

    def valid_signed_request? # :nodoc:
      signed_request_param_text_is_valid? && verify_signed_request
    end

    def signed_request_param_text_is_valid? # :nodoc:
      params['signed_request'].split(".")[1].present?
    end
    
    def facebook_session? # :nodoc:
      facebook_session.present?
    end
    
    def parse_fb_cookies # :nodoc:
      MiniFB.parse_cookie_information(FB_APP_ID, cookies)
    end
    
    def parse_signed_request # :nodoc:
      params['signed_request'] = JSON.parse(MiniFB.base64_url_decode(params['signed_request'].split(".")[1]))
    end
    
    def verify_cookie_signature # :nodoc:
      MiniFB.verify_cookie_signature(FB_APP_ID, FB_SECRET, cookies)
    end
    
    def verify_signed_request # :nodoc:
      MiniFB.verify_signed_request(FB_SECRET, params['signed_request'])
    end
  
  end

end
