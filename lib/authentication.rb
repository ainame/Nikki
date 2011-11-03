# -*- coding: utf-8 -*-
class Nikki < Sinatra::Base
  get '/oauth' do
    redirect Nikki.rixi.authorized_uri
  end

  def get_old_mixi_member_id(profile_url)
    # todo: 旧IDを取得する手段を実装
  end

  get '/callback' do
    mixi = Nikki.rixi.get_token(params[:code])
    response = mixi.people "@me", "@self"
    session[:signin] = true
    session[:screen_name]   = response["entry"]["displayName"]
    session[:uid]           = response["entry"]["id"]    
    session[:thumbnailUrl]  = response["entry"]["thumbnailUrl"]    
    session[:access_token]  = mixi.token.token
    session[:refresh_token] = mixi.token.refresh_token
    session[:expires_in]    = mixi.token.expires_in
    #session[:owner_id]      = get_old_mixi_member_id(response["entry"]["profileUrl"])

    redirect '/'
  end

  get '/signout' do
    session[:signin] = false
    session[:access_token] = nil
    session[:refresh_token] = nil
    session[:expires_in] = nil
    redirect '/'
  end

  # OmniAuth's method
  get '/auth/:provider/callback' do   
    auth = request.env['omniauth.auth']
    provider = params[:provider].to_sym
    session[provider] = {}
    session[provider][:access_token]  = auth["credentials"]["token"]
    session[provider][:access_secret] = auth["credentials"]["secret"] || nil
    session[provider][:screen_name]   = auth["user_info"]["nickname"]
    flash[:notice] = params[:provider]+"にログインしました"
    redirect '/'
  end

  get '/signout/:provider' do   
    provider = params[:provider].to_sym
    session[provider] = nil
    redirect '/'
  end


  get '/auth/failure' do 
    redirect '/'
  end
end
