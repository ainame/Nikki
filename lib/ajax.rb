# -*- coding: utf-8 -*-

# ajaxリクエスト用
class Nikki < Sinatra::Base
  @@ajax_request_methods = { 
    "mixi_voice" => "mixi_voice",
    "twitter"    => "",
    "mixi_photo" => "",
    "instagram"  => "",
    "foursquare" => "",
    
  }
  
  get '/ajax/:service' do 
    self.call(params[:service])
  end

  

end

