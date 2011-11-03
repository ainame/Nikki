require 'json'
require 'twitter'

class Nikki < Sinatra::Base
  get '/twitter' do 
    content_type :json
    # Twitter.configure do |tw|
    #   tw.conumer_key     = @@config['tw_consumer_key']
    #   tw.consumer_secret = @@config['tw_consumer_secret']
    #   tw.access_token    = session[:twitter][:access_token]
    #   tw.access_secret   = session[:twitter][:access_secret]
    # end
    @twitter = Twitter.user_timeline("ainame")
  end
  
end
