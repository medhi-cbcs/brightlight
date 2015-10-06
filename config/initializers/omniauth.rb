Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], name: 'google', 
  		scope: 'profile', image_aspect_ratio: 'square', image_size: 48, access_type: 'online', skip_jwt: true
end

# skip_jwt option is a work around an issue that happens sometimes on Windows platform
# https://github.com/zquestz/omniauth-google-oauth2/issues/195