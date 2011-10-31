require 'test_helper'

class DummyController < ApplicationController
  
  before_filter :ensure_valid_facebook_signed_request, :only => [:fb_signed_request]

  before_filter :ensure_facebook_session, :only => [:fb_cookies]
  
  def fb_signed_request
    render :text => "ok"
  end
  
  def fb_cookies
    render :text => "ok"
  end
  
end

class TestMiniFbRails < ActionController::TestCase

  tests DummyController

  def setup
    Dummy::Application.routes.draw do
      match '/' => "dummy#index", :as => :root
      match '/fb_cookies' => "dummy#fb_cookies"
      match '/fb_signed_request' => "dummy#fb_signed_request" 
    end    
  end
  
  def teardown
    Rails.application.reload_routes!
  end
  
  test "redirects when if the facebook session is not present" do
    get :fb_cookies
    assert_response :redirect
  end

  test "redirects when if the facebook cookies are not valid" do
    @controller.expects(:facebook_session).at_least_once.returns({:test => "A"})
    get :fb_cookies
    assert_response :unauthorized
  end
  
  test "renders if the facebook session is present and the facebook cookies are valid" do
    @request.cookies["fbs_132911716782327"] = "access_token=132911716782327|2.S_rN_lhTMEZpPz5nq0ApEw__.3600.1302267600-668896411|hWNljvsCOphbzWJ3mffxz4kLi50&expires=1302267600&secret=rq8hhOyAKijb2q_1ToXrsw__&session_key=2.S_rN_lhTMEZpPz5nq0ApEw__.3600.1302267600-668896411&sig=d9cefa8c4c6044d7df1a356c5af501f6&uid=668896411"
    get :fb_cookies
    assert_response :success
    assert_equal MiniFB.parse_cookie_information(FB_APP_ID, @request.cookies), @controller.facebook_session
  end

  test "unauthorize requests without a facebook signed request" do
    get :fb_signed_request
    assert_response :unauthorized
    assert_equal "Invalid Facebook Request", @response.body
  end

  test "unauthorize request when the facebook signed request is not valid" do
    get :fb_signed_request, {:signed_request => "www"}
    assert_response :unauthorized
    assert_equal "Invalid Facebook Request", @response.body
  end
  
  test "requests with valid facebook signed params" do
    signed_request = "C6P2VhPuXNRFGHdDhajuGc8_819FGOuAvGTemqdaIDw.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEzMDM4MzcyMDAsImlzc3VlZF9hdCI6MTMwMzgzMjM4Niwib2F1dGhfdG9rZW4iOiIxMzI5MTE3MTY3ODIzMjd8Mi5fT2t1amVSdXdnenc4R1l6djJfTGN3X18uMzYwMC4xMzAzODM3MjAwLjEtNjY4ODk2NDExfHRzVHR5Wk1aSm1EVGhmY1JZNnkyVHJhMExPdyIsInJlZ2lzdHJhdGlvbiI6eyJuYW1lIjoiTWFyY29zIE1iaWRhLUVzc2luZGkiLCJlbWFpbCI6Im1hcmNlc3NpbmRpXHUwMDQwZ21haWwuY29tIiwiYmlydGhkYXkiOiIwNFwvMTJcLzE5NzYiLCJnZW5kZXIiOiJtYWxlIiwicGhvbmUiOiI2NzcwNTI4MTMifSwicmVnaXN0cmF0aW9uX21ldGFkYXRhIjp7ImZpZWxkcyI6Ilt7J25hbWUnOiduYW1lJ30sIHsnbmFtZSc6J2VtYWlsJ30sIHsnbmFtZSc6J2JpcnRoZGF5J30sIHsnbmFtZSc6J2dlbmRlcid9LCB7J25hbWUnOidwaG9uZScsICAgICAgJ2Rlc2NyaXB0aW9uJzonUGhvbmUgTnVtYmVyJywndHlwZSc6J3RleHQnfV0ifSwidXNlciI6eyJjb3VudHJ5IjoiZXMiLCJsb2NhbGUiOiJlbl9VUyJ9LCJ1c2VyX2lkIjoiNjY4ODk2NDExIn0"
    get :fb_signed_request, {:signed_request => signed_request}
    assert_response :ok
    assert_equal "ok", @response.body
    parsed_signed_request = JSON.parse(MiniFB.base64_url_decode(signed_request.split(".")[1]))
    assert_equal parsed_signed_request, @controller.params['signed_request']
  end
    
end