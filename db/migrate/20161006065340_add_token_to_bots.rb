class AddTokenToBots < ActiveRecord::Migration
  def up
    add_column :bots, :token, :string, limit: 64, null: false, after: :no_classified_answer_id
    Bot.find_each do |bot|
      bot.update(token: SecureRandom.hex(32))
    end
  end

  def down
    remove_column :bots, :token
  end
end
