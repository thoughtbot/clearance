require "spec_helper"

describe Clearance::Passkey do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:label) }
  it { is_expected.to validate_presence_of(:external_id) }
  it { is_expected.to validate_presence_of(:public_key) }
  it { is_expected.to have_db_index(:external_id).unique(true) }
  it { is_expected.to have_db_column(:sign_count).with_options(null: false, default: 0) }

  it "rejects a duplicate external_id" do
    user = create(:user)
    create(:passkey, user: user, external_id: "cred_abc")
    duplicate = build(:passkey, user: user, external_id: "cred_abc")

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:external_id]).not_to be_empty
  end

  it "allows the same external_id to be used after the original is destroyed" do
    user = create(:user)
    passkey = create(:passkey, user: user, external_id: "cred_abc")
    passkey.destroy
    new_passkey = build(:passkey, user: user, external_id: "cred_abc")

    expect(new_passkey).to be_valid
  end
end
