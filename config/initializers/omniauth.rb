Rails.application.config.middleware.use OmniAuth::Builder do
  fb_app_id = ENV['SLIDESTREAM_FACEBOOK_APP_ID']
  fb_app_secret = ENV['SLIDESTREAM_FACEBOOK_APP_SECRET']
  provider :facebook, fb_app_id, fb_app_secret,
           :scope => 'email, publish_stream'
end
