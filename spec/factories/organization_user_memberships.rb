FactoryGirl.define do
  factory :organization_user_membership, class: 'Organization::UserMembership' do
    user_id 1
    organization_id 1
  end
end
