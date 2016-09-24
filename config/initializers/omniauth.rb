Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'], scope: 'email, public_profile, publish_actions, manage_pages, pages_show_list, pages_messaging, publish_pages, user_managed_groups'
end

OmniAuth.config.on_failure = proc do |env|
  ConnectionsController.action(:omniauth_failure).call(env)
end
