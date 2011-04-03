require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # db

  should have_db_index(:email)
  should have_db_index(:remember_token)

  # signing up

  context "When signing up" do
    should validate_presence_of(:email)
    should validate_presence_of(:password)
    should allow_value("foo@example.co.uk").for(:email)
    should allow_value("foo@example.com").for(:email)
    should_not allow_value("foo@").for(:email)
    should_not allow_value("foo@example..com").for(:email)
    should_not allow_value("foo@.example.com").for(:email)
    should_not allow_value("foo").for(:email)
    should_not allow_value("example.com").for(:email)

    should "require password confirmation on create" do
      user = Factory.build(:user, :password              => 'blah',
                                  :password_confirmation => 'boogidy')
      assert ! user.save
      assert user.errors[:password].any?
    end

    should "require non blank password confirmation on create" do
      user = Factory.build(:user, :password              => 'blah',
                                  :password_confirmation => '')
      assert ! user.save
      assert user.errors[:password].any?
    end

    should "initialize salt" do
      assert_not_nil Factory(:user).salt
    end

    context "encrypt password" do
      setup do
        @salt = "salt"
        @user = Factory.build(:user, :salt => @salt)
        def @user.initialize_salt; end
        @user.save!
        @password = @user.password

        @user.send(:encrypt, @password)
        @expected = Digest::SHA1.hexdigest("--#{@salt}--#{@password}--")
      end

      should "create an encrypted password using SHA1 encryption" do
        assert_equal @expected, @user.encrypted_password
      end
    end

    should "store email in exact case" do
      user = Factory(:user, :email => "John.Doe@example.com")
      assert_equal "John.Doe@example.com", user.email
    end
  end

  context "When multiple users have signed up" do
    setup { Factory(:user) }
    should validate_uniqueness_of(:email)
  end

  # authenticating

  context "A user" do
    setup do
      @user     = Factory(:user)
      @password = @user.password
    end

    should "authenticate with good credentials" do
      assert ::User.authenticate(@user.email, @password)
      assert @user.authenticated?(@password)
    end

    should "not authenticate with bad credentials" do
      assert ! ::User.authenticate(@user.email, 'bad_password')
      assert ! @user.authenticated?('bad_password')
    end
  end

  # resetting remember token

  context "When resetting authentication with reset_remember_token!" do
    setup do
      @user  = Factory(:user)
      @user.remember_token = "old-token"
      @user.reset_remember_token!
    end

    should "change the remember token" do
      assert_not_equal "old-token", @user.remember_token
    end
  end

  # updating password

  context "An email confirmed user" do
    setup do
      @user = Factory(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    context "who updates password with confirmation" do
      setup do
        @user.update_password("new_password", "new_password")
      end

      should "change encrypted password" do
        assert_not_equal @user.encrypted_password,
                         @old_encrypted_password
      end
    end
  end

  should "not generate the same remember token for users with the same password at the same time" do
    Time.stubs(:now => Time.now)
    password    = 'secret'
    first_user  = Factory(:user,
                          :password              => password,
                          :password_confirmation => password)
    second_user = Factory(:user,
                          :password              => password,
                          :password_confirmation => password)

    assert_not_equal first_user.remember_token, second_user.remember_token
  end

  # recovering forgotten password

  context "An user" do
    setup do
      @user = Factory(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    context "who requests password reminder" do
      setup do
        assert_nil @user.confirmation_token
        @user.forgot_password!
      end

      should "generate confirmation token" do
        assert_not_nil @user.confirmation_token
      end

      context "and then updates password" do
        context 'with confirmation' do
          setup do
            @user.update_password("new_password", "new_password")
          end

          should "change encrypted password" do
            assert_not_equal @user.encrypted_password,
                             @old_encrypted_password
          end

          should "clear confirmation token" do
            assert_nil @user.confirmation_token
          end
        end

        context 'without confirmation' do
          setup do
            @user.update_password("new_password", "")
          end

          should "not change encrypted password" do
            assert_equal @user.encrypted_password,
                         @old_encrypted_password
          end

          should "not clear confirmation token" do
            assert_not_nil @user.confirmation_token
          end
        end

        context 'try to update with blank password and confirmation' do
          setup do
            @user.update_password("", "")
          end

          should "not change encrypted password" do
            assert_equal @user.encrypted_password,
                         @old_encrypted_password
          end

          should "not clear confirmation token" do
            assert_not_nil @user.confirmation_token
          end
        end
      end
    end

  end

  # optional email/password fields
  context "a user with an optional email" do
    setup do
      @user = User.new
      class << @user
        def email_optional?
          true
        end
      end
    end

    subject { @user }

    should allow_value(nil).for(:email)
    should allow_value("").for(:email)
  end

  context "a user with an optional password" do
    setup do
      @user = User.new
      class << @user
        def password_optional?
          true
        end
      end
    end

    subject { @user }

    should allow_value(nil).for(:password)
    should allow_value("").for(:password)
  end

  context "user factory" do
    should "create a valid user with just an overridden password" do
      assert Factory.build(:user, :password => "test").valid?
    end
  end

  context "when user exists before Clearance was installed" do
    setup do
      @user = Factory(:user)
      sql  = "update users set salt = NULL, encrypted_password = NULL, remember_token = NULL where id = #{@user.id}"
      ActiveRecord::Base.connection.update(sql)
      assert_nil @user.reload.salt
      assert_nil @user.reload.encrypted_password
      assert_nil @user.reload.remember_token
    end

    should "initialize salt, generate remember token, and save encrypted password on update_password" do
      @user.update_password('password', 'password')
      assert_not_nil @user.salt
      assert_not_nil @user.encrypted_password
      assert_not_nil @user.remember_token
    end
  end
end
