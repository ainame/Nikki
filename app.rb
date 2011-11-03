# -*- coding: utf-8 -*-
require 'sinatra/base'
require 'padrino-helpers'
require 'rixi'
require 'slim'
require 'rack/flash'
require 'open-uri'
require 'oa-oauth'
require 'active_support'
require 'instagram'
require 'twitter'
require_relative 'lib/authentication'
require_relative 'lib/get_instance'
require_relative 'lib/submit'
require_relative 'lib/static_page'

# 設定とトップ画面だけを書く
class Nikki < Sinatra::Base
  register Padrino::Helpers

  configure do
    enable :sessions
    set :public_folder, File.dirname(__FILE__) + '/public'
    @@scope = { 
      :r_profile => true,
      :r_voice => true,
      :w_voice => true,
      :r_photo => true,
      :w_photo  => true,
      :w_diary => true,
      :r_updates => true
    }
  end
  
  configure :development do
    require 'pp' if :development
    require 'sinatra/reloader' if :development

    register Sinatra::Reloader
    Slim::Engine.set_default_options :pretty => true
    @@config = JSON.parse(open("./setting.json").read)
    use Rack::Flash
    use OmniAuth::Strategies::Twitter, @@config['tw_consumer_key'], @@config['tw_consumer_secret']
    use OmniAuth::Strategies::Instagram, @@config['instagram_consumer_key'], @@config['instagram_consumer_secret']
    Instagram.configure do |config|
      config.client_id = @@config['instagram_consumer_key']
      config.client_secret = @@config['instagram_consumer_secret']
    end
  end
   
  configure :production do
    set :session_secret, ENV['SESSION_KEY']
    use Rack::Flash
    use OmniAuth::Strategies::Twitter, ENV['tw_consumer_key'], ENV['tw_consumer_secret']
    use OmniAuth::Strategies::Instagram, ENV['instagram_consumer_key'], ENV['instagram_consumer_secret']
    Instagram.configure do |config|
      config.client_id = ENV['instagram_consumer_key']
      config.client_secret = ENV['instagram_consumer_secret']
    end
    @@config = { 
      'consumer_key'    => ENV['consumer_key'],
      'consumer_secret' => ENV['consumer_secret'],
      'redirect_uri'    => ENV['redirect_uri']
    }
  end

  get '/' do
    if session[:signin]
      mixi = Nikki.rixi.set_token(session[:access_token],
                                 session[:refresh_token],
                                 session[:expires_in])
      @mixi_photo = mixi.photos_in_album "@me", "@default"
      @mixi_voice = mixi.user_timeline "@me"      

      if session[:twitter]
        @twitter = Twitter.user_timeline(session[:twitter][:screen_name])
      end

      if session[:instagram] 
        @instagram = Nikki.get_instagram_user(session[:instagram][:access_token]) 
      end

      # 右カラムのメニューのタイトルロゴ的に使う奴
      @partial_title = ["今日のあなたは何してた？",
                        "日記を写真で飾ろう",
                        "今日は何を食べた？"].sample
      slim :index
    else
      # 非ログイン時のトップページの一言
      @phrase = ["今日の出来事をまとめよう",
                 "たのしい日記をお手軽に",
                 "あなたの毎日を鮮やかに"].sample
      slim :top
    end
  end

  run! if app_file == $0
end
