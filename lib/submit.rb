# -*- coding: utf-8 -*-

class Nikki < Sinatra::Base
  #日記の送信に関する処理をまとめる
  post '/submit' do
    mixi = Nikki.rixi.set_token(session[:access_token],
                                session[:refresh_token],
                                session[:expires_in])
    entry = {
      :json => { 
        :title => params[:title] || "無題",
        :body  => CGI.unescape(params[:body] || "本文なし"),
        :privacy => {
          :visibility => "friends"
        }
      }
    }

    #TODO: mixiフォトに既にアップロードされてる部分は
    #      新規にアップロードせずに、IDでの挿入を。
    #      それ以外はアップロードを。
    #      Ajaxを用いてアップロードする領域とD&Dで
    #      挿入できる領域を分ける

    imgs = Array.new
    photo_ids = Array.new
    
    begin
      params.each do |key, value|
        if key =~ /^photo([0-9]+)/ && value != ""
          if $1.to_i < 3
            imgs.push(open(value).read)
          else
            response = mixi.upload_photo("@me", "@default", :image => open(value).read)
            photo_ids.push response["id"]
          end
        end
      end
    rescue => error
      flash[:error] = "画像を取得できませんでした<br />#{error.message}"
      redirect '/'
    end

    entry.merge!({:image => imgs}) unless imgs.empty?
    photo_ids.each do |photo_id|
      entry[:json][:body] = entry[:json][:body] + "\r\n\r\n<photo src='v2:#{ photo_id.to_s}'>"
    end

    response = mixi.diary entry
    # if response["id"]
    #   redirect "http://mixi.jp/view_diary.pl?id=#{response["id"]}&uid=#{session[:uid]}" 
    # else
    #  redirect '/'
    # end
    redirect 'http://mixi.jp/list_diary.pl'
  end

end
