FactoryGirl.define do
  factory :answer_inline_image do
    file { Rails.root.join('spec/fixtures/images/sample_naoki.jpg').open }
  end
end