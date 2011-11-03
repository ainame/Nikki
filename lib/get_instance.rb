class Nikki
  def self.get_instagram_user(access_token)
    client = Instagram.client(:access_token => access_token)
    images = Array.new
    for media_item in client.user_recent_media
      images << media_item["images"]
    end
    images
  end
  
  def self.rixi
    return @@mixi ||= Rixi.new(
                               :consumer_key => @@config["consumer_key"],
                               :consumer_secret => @@config["consumer_secret"],
                               :redirect_uri => @@config["redirect_uri"],
                               :scope => @@scope,
                               :connection_opts => { :proxy => ENV["https_proxy"] },
                               :raise_errors => false
                               )
  end
end
