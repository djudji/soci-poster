class Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :content
  validates_presence_of :scheduled_at
  validates_length_of :content, maximum: 140, message: 'Less then 140 characters please'
  validates_datetime :scheduled_at, on: :create, on_or_after: Time.zone.now
  after_create :schedule

  scope :scheduled, -> { where(state: 'scheduled').order('scheduled_at ASC') }
  scope :history,   -> { where.not(state: 'scheduled').order('scheduled_at DESC') }

  def to_twitter
    client = Twitter::REST::Client.new do |config|
      config.access_token = user.twitter.oauth_token
      config.access_token_secret = user.twitter.secret
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
    end
    client.update(content)
  end

  def to_facebook
    user_graph = Koala::Facebook::API.new(user.facebook.oauth_token)
    user_graph.put_connections('me', 'feed', message: content)
  end

  def to_facebook_page(name = 'Judo Klub Tuzla')
    user_graph = Koala::Facebook::API.new(user.facebook.oauth_token)
    pages = user_graph.get_connections('me', 'accounts')
    fb_page = pages.select { |page| page['name'] == name }
    page_access_token = fb_page[0]['access_token']
    page_graph = Koala::Facebook::API.new(page_access_token)
    page_graph.put_connections('me', 'feed', message: content)
  end

  def display
    return unless state == 'canceled'
    to_twitter if twitter
    to_facebook if facebook
    to_facebook_page if facebook_page
    update_attributes(state: 'posted')
  rescue StandardError => e
    update_attributes(state: 'posting error', error: e.message)
  end

  def schedule
    SchedulePostsJob.set(wait_until: scheduled_at).perform_later(self)
    update_attributes(state: 'scheduled')
  rescue StandardError => e
    update_attributes(state: 'scheduled error', error: e.message)
  end
end
