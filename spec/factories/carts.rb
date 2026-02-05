FactoryBot.define do
  factory :cart do
    status { :active }
    total_price { 0.0 }
    last_interaction_at { Time.current }
  end
end
