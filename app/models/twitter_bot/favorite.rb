class TwitterBot::Favorite < TwitterBot::Base
  def all
    FavoriteWord.all.each { |favorite_word| single(favorite_word.word) }
  end

  def single(search_word)
    str = "#{search_word} -RT"
    puts str

    tweets = client.search(str)
      .select{|t| t.user.screen_name != BOT_SCREEN_NAME}
      .select{|t| t.text.downcase.include?(search_word.downcase)}

    tweets.each_with_index do |tweet, index|
      next if tweet.favorited?
      break if index > 0 # 最新の1件のみを処理する(favoriteし過ぎないようにするため)

      puts tweet.text
      # client.favorite(tweet.id)
    end
  end
end
