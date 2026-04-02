FactoryBot.define do
  factory :passkey, class: "Clearance::Passkey" do
    user
    label { "My Key" }
    sequence(:external_id) { |n| "external_id_#{n}" }
    public_key { "public_key_data" }
    sign_count { 0 }
  end
end
