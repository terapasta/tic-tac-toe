namespace :user do
  task import_csv: :environment do
    data = CSV.parse(Rails.root.join(ENV['path']).read)
    organization = Organization.find(ENV['org_id'])
    ActiveRecord::Base.transaction do
      data.each do |datum|
        user = User.create!(email: datum[0], password: datum[1])
        organization.user_memberships.create!(user: user)
      end
    end
  end
end