require 'spec_helper'

describe User do
  it { should have_db_index(:email) }
  it { should have_db_index(:remember_token) }

  describe "When signing up" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should allow_value("foo@example.co.uk").for(:email) }
    it { should allow_value("foo@example.com").for(:email) }
    it { should_not allow_value("foo@").for(:email) }
    it { should_not allow_value("foo@example..com").for(:email) }
    it { should_not allow_value("foo@.example.com").for(:email) }
    it { should_not allow_value("foo").for(:email) }
    it { should_not allow_value("example.com").for(:email) }

    it "should store email in down case" do
      user = Factory(:user, :email => "John.Doe@example.com")
      user.email.should == "john.doe@example.com"
    end
  end

  describe "When multiple users have signed up" do
    before { Factory(:user) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "A user" do
    before do
      @user     = Factory(:user)
      @password = @user.password
    end

    it "is authenticated with correct email and password" do
      (::User.authenticate(@user.email, @password)).should be
      @user.should be_authenticated(@password)
    end

    it "is authenticated with correct uppercased email and correct password" do
      (::User.authenticate(@user.email.upcase, @password)).should be
      @user.should be_authenticated(@password)
    end

    it "is authenticated with incorrect credentials" do
      (::User.authenticate(@user.email, 'bad_password')).should_not be
      @user.should_not be_authenticated('bad password')
    end
  end

  describe "When resetting authentication with reset_remember_token!" do
    before do
      @user  = Factory(:user)
      @user.remember_token = "old-token"
      @user.reset_remember_token!
    end

    it "should change the remember token" do
      @user.remember_token.should_not == "old-token"
    end
  end

  describe "An email confirmed user" do
    before do
      @user = Factory(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    describe "who updates password" do
      before do
        @user.update_password("new_password")
      end

      it "should change encrypted password" do
        @user.encrypted_password.should_not == @old_encrypted_password
      end
    end
  end

  it "should not generate the same remember token for users with the same password at the same time" do
    Time.stubs(:now => Time.now)
    password    = 'secret'
    first_user  = Factory(:user, :password => password)
    second_user = Factory(:user, :password => password)

    second_user.remember_token.should_not == first_user.remember_token
  end

  describe "An user" do
    before do
      @user = Factory(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    describe "who requests password reminder" do
      before do
        @user.confirmation_token.should be_nil
        @user.forgot_password!
      end

      it "should generate confirmation token" do
        @user.confirmation_token.should_not be_nil
      end

      describe "and then updates password" do
        describe 'with password' do
          before do
            @user.update_password("new_password")
          end

          it "should change encrypted password" do
            @user.encrypted_password.should_not == @old_encrypted_password
          end

          it "should clear confirmation token" do
            @user.confirmation_token.should be_nil
          end
        end

        describe 'with blank password' do
          before do
            @user.update_password("")
          end

          it "does not change encrypted password" do
            @user.encrypted_password.should == @old_encrypted_password
          end

          it "does not clear confirmation token" do
            @user.confirmation_token.should_not be_nil
          end
        end
      end
    end
  end

  describe "a user with an optional email" do
    before do
      @user = User.new
      class << @user
        def email_optional?
          true
        end
      end
    end

    subject { @user }

    it { should allow_value(nil).for(:email) }
    it { should allow_value("").for(:email) }
  end

  describe "a user with an optional password" do
    before do
      @user = User.new
      class << @user
        def password_optional?
          true
        end
      end
    end

    subject { @user }

    it { should allow_value(nil).for(:password) }
    it { should allow_value("").for(:password) }
  end

  describe "user factory" do
    it "should create a valid user with just an overridden password" do
      Factory.build(:user, :password => "test").should be_valid
    end
  end

  describe "when user exists before Clearance was installed" do
    before do
      @user = Factory(:user)
      sql  = "update users set salt = NULL, encrypted_password = NULL, remember_token = NULL where id = #{@user.id}"
      ActiveRecord::Base.connection.update(sql)
      @user.reload.salt.should be_nil
      @user.reload.encrypted_password.should be_nil
      @user.reload.remember_token.should be_nil
    end

    it "should initialize salt, generate remember token, and save encrypted password on update_password" do
      @user.update_password('password')
      @user.salt.should_not be_nil
      @user.encrypted_password.should_not be_nil
      @user.remember_token.should_not be_nil
    end
  end

  describe "The password setter on a User" do
    let(:password) { "a-password" }
    before { subject.send(:password=, password) }

    it "sets password to the plain-text password" do
      subject.password.should == password
    end

    it "also sets encrypted_password" do
      subject.encrypted_password.should_not be_nil
    end
  end
end
