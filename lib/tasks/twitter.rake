namespace :twitter do
  task reply: :environment do
    TwitterBot.new.reply
  end

  task favorite: :environment do
    TwitterBot.new.favorite_all
  end
end
