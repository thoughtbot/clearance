require "spec_helper"

describe User do
  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:remember_token) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to allow_value("foo@example.co.uk").for(:email) }
  it { is_expected.to allow_value("foo@example.com").for(:email) }
  it { is_expected.to allow_value("foo+bar@example.com").for(:email) }
  it { is_expected.not_to allow_value("foo@").for(:email) }
  it { is_expected.not_to allow_value("foo@example..com").for(:email) }
  it { is_expected.not_to allow_value("foo@.example.com").for(:email) }
  it { is_expected.not_to allow_value("foo").for(:email) }
  it { is_expected.not_to allow_value("example.com").for(:email) }
  it { is_expected.not_to allow_value("foo;@example.com").for(:email) }

  describe "#email" do
    it "stores email in down case and removes whitespace" do
      user = create(:user, email: "Jo hn.Do e @exa mp le.c om")

      expect(user.email).to eq "john.doe@example.com"
    end

    subject { create(:user) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe ".authenticate" do
    it "is authenticated with correct email and password" do
      user = create(:user)
      password = user.password

      expect(User.authenticate(user.email, password)).to eq(user)
    end

    it "is authenticated with correct uppercased email and correct password" do
      user = create(:user)
      password = user.password

      expect(User.authenticate(user.email.upcase, password)).to eq(user)
    end

    it "is not authenticated with incorrect credentials" do
      user = create(:user)

      expect(User.authenticate(user.email, "bad_password")).to be_nil
    end

    it "is retrieved via a case-insensitive search" do
      user = create(:user)

      expect(User.find_by_normalized_email(user.email.upcase)).to eq(user)
    end
  end

  describe ".reset_remember_token" do
    context "when resetting authentication with reset_remember_token!" do
      it "changes the remember token" do
        old_token = "old_token"
        user = create(:user, remember_token: old_token)

        user.reset_remember_token!

        expect(user.remember_token).not_to eq old_token
      end
    end
  end

  describe "#update_password" do
    context "with a valid password" do
      it "changes the encrypted password" do
        user = create(:user, :with_forgotten_password)
        old_encrypted_password = user.encrypted_password

        user.update_password("new_password")

        expect(user.encrypted_password).not_to eq old_encrypted_password
      end

      it "clears the confirmation token" do
        user = create(:user, :with_forgotten_password)

        user.update_password("new_password")

        expect(user.confirmation_token).to be_nil
      end

      it "sets the remember token" do
        user = create(:user, :with_forgotten_password)

        user.update_password("my_new_password")

        user.reload
        expect(user.remember_token).not_to be_nil
      end
    end

    context "with blank password" do
      it "does not change the encrypted password" do
        user = create(:user, :with_forgotten_password)
        old_encrypted_password = user.encrypted_password

        user.update_password("")

        expect(user.encrypted_password.to_s).to eq old_encrypted_password
      end

      it "does not clear the confirmation token" do
        user = create(:user, :with_forgotten_password)

        user.update_password("")

        expect(user.confirmation_token).not_to be_nil
      end
    end
  end

  describe "before_create callbacks" do
    describe "#generate_remember_token" do
      it "does not generate same remember token for users with same password" do
        allow(Time).to receive(:now).and_return(Time.now)
        password = "secret"
        first_user = create(:user, password: password)
        second_user = create(:user, password: password)

        expect(second_user.remember_token).not_to eq first_user.remember_token
      end
    end
  end

  describe "#forgot_password!" do
    it "generates the confirmation token" do
      user = create(:user, confirmation_token: nil)

      user.forgot_password!

      expect(user.confirmation_token).not_to be_nil
    end
  end

  describe "a user with an optional email" do
    subject { user }

    it { is_expected.to allow_value(nil).for(:email) }
    it { is_expected.to allow_value("").for(:email) }

    def user
      @user ||= User.new
      allow(@user).to receive(:email_optional?).and_return(true)
      @user
    end
  end

  describe "user factory" do
    it "should create a valid user with just an overridden password" do
      expect(build(:user, password: "test")).to be_valid
    end
  end

  describe "email address normalization" do
    it "downcases the address and strips spaces" do
      email = "Jo hn.Do e @exa mp le.c om"

      expect(User.normalize_email(email)).to eq "john.doe@example.com"
    end
  end

  describe "the password setter on a User" do
    it "sets password to the plain-text password" do
      password = "password"
      subject.send(:password=, password)

      expect(subject.password).to eq password
    end

    it "also sets encrypted_password" do
      password = "password"
      subject.send(:password=, password)

      expect(subject.encrypted_password).to_not be_nil
    end
  end
end

describe UserWithOptionalPassword do
  it { is_expected.to allow_value(nil).for(:password) }
  it { is_expected.to allow_value("").for(:password) }

  it "cannot authenticate with blank password" do
    user = create(:user_with_optional_password)

    expect(UserWithOptionalPassword.authenticate(user.email, "")).to be_nil
  end
end
