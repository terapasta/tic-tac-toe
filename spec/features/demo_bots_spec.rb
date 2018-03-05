require 'rails_helper'

RSpec.describe 'DemoBots', type: :feature, js: true do
  include RequestSpecHelper

  let!(:staff) do
    create(:user, role: :staff)
  end

  let!(:bot_owner) do
    create(:user, role: :normal)
  end

  let!(:bot) do
    create(:bot, is_demo: true)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: bot_owner)
      org.bot_ownerships.create(bot: bot)
    end
  end

  before do
    sign_in staff
  end
  
  scenario 'Finish Demoボタンを押す' do
    visit "/admin/demo_bots"
    expect(page).not_to have_content('デモが終了しています')
    click_link 'Finish demo'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content('デモが終了しています')
  end
end