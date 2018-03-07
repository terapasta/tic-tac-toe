FactoryGirl.define do
  factory :answer_file do
    file { Rails.root.join('spec/fixtures/images/sample_naoki.jpg').open }
  end
end
