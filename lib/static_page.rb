# -*- coding: utf-8 -*-

#静的ページへのリンクをまとめる
class Nikki < Sinatra::Base

  get '/about' do 
    slim :about
  end

  get '/admin-profile' do 
    slim :admin_profile
  end

end
