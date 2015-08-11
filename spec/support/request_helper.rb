shared_context "setup_OmniAuth_config" do |service|
  before do
    OmniAuth.config.test_mode = true

    oauthinfo = {
      uid:    Forgery('basic').number,
      name:   Forgery('name').name,
      email:  Forgery('email').address,
      token:  Forgery('basic').encrypt,
    }
    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new(
      {
        name:       oauthinfo[:name],
        provider:   service.to_s,
        uid:        oauthinfo[:uid],
        info: {
          name:     oauthinfo[:name],
          email:    oauthinfo[:email],
        },
        credentials: {
          token:    oauthinfo[:token],
        },
      }
    )
  end

  let(:oauth_user) { OmniAuth.config.mock_auth[service] }
end
