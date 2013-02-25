require 'spec_helper'

describe User do
  it { should have_db_index(:email) }
  it { should have_db_index(:remember_token) }

  describe 'when signing up' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should allow_value('foo@example.co.uk').for(:email) }
    it { should allow_value('foo@example.com').for(:email) }
    it { should_not allow_value('foo@').for(:email) }
    it { should_not allow_value('foo@example..com').for(:email) }
    it { should_not allow_value('foo@.example.com').for(:email) }
    it { should_not allow_value('foo').for(:email) }
    it { should_not allow_value('example.com').for(:email) }

    it 'stores email in down case and removes whitespace' do
      user = create(:user, :email => 'Jo hn.Do e @exa mp le.c om')
      user.email.should == 'john.doe@example.com'
    end
  end

  describe 'when multiple users have signed up' do
    before { create(:user) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'a user' do
    before do
      @user = create(:user)
      @password = @user.password
    end

    it 'is authenticated with correct email and password' do
      User.authenticate(@user.email, @password).should be(true)
      @user.should be_authenticated(@password)
    end

    it 'is authenticated with correct uppercased email and correct password' do
      User.authenticate(@user.email.upcase, @password).should be(true)
      @user.should be_authenticated(@password)
    end

    it 'is authenticated with incorrect credentials' do
      User.authenticate(@user.email, 'bad_password').should be(false)
      @user.should_not be_authenticated('bad password')
    end

    it 'is retrieved via a case-insensitive search' do
      User.find_by_normalized_email(@user.email.upcase).should eq(@user)
    end
  end

  describe 'when resetting authentication with reset_remember_token!' do
    before do
      @user = create(:user)
      @user.remember_token = 'old-token'
      @user.reset_remember_token!
    end

    it 'changes the remember token' do
      @user.remember_token.should_not == 'old-token'
    end
  end

  describe 'an email confirmed user' do
    before do
      @user = create(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    describe 'who updates password' do
      before do
        @user.update_password('new_password')
      end

      it 'changes encrypted password' do
        @user.encrypted_password.should_not == @old_encrypted_password
      end
    end
  end

  it 'does not generate same remember token for users with same password at same time' do
    Time.stubs :now => Time.now
    password = 'secret'
    first_user = create(:user, :password => password)
    second_user = create(:user, :password => password)
    second_user.remember_token.should_not == first_user.remember_token
  end

  describe 'a user' do
    before do
      @user = create(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    describe 'who requests password reminder' do
      before do
        @user.confirmation_token.should be_nil
        @user.forgot_password!
      end

      it 'generates confirmation token' do
        @user.confirmation_token.should_not be_nil
      end

      describe 'and then updates password' do
        describe 'with password' do
          before do
            @user.update_password 'new_password'
          end

          it 'changes encrypted password' do
            @user.encrypted_password.should_not == @old_encrypted_password
          end

          it 'clears confirmation token' do
            @user.confirmation_token.should be_nil
          end
        end

        describe 'with blank password' do
          before do
            @user.update_password ''
          end

          it 'does not change encrypted password' do
            @user.encrypted_password.should == @old_encrypted_password
          end

          it 'does not clear confirmation token' do
            @user.confirmation_token.should_not be_nil
          end
        end
      end
    end
  end

  describe 'a user with an optional email' do
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
    it { should allow_value('').for(:email) }
  end

  describe 'a user with an optional password' do
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
    it { should allow_value('').for(:password) }
  end

  describe 'user factory' do
    it 'should create a valid user with just an overridden password' do
      build(:user, :password => 'test').should be_valid
    end
  end

  describe 'email address normalization' do
    let(:email) { 'Jo hn.Do e @exa mp le.c om' }

    it 'downcases the address and strips spaces' do
      User.normalize_email(email).should eq 'john.doe@example.com'
    end
  end

  describe 'the password setter on a User' do
    let(:password) { 'a-password' }
    before { subject.send(:password=, password) }

    it 'sets password to the plain-text password' do
      subject.password.should == password
    end

    it 'also sets encrypted_password' do
      subject.encrypted_password.should_not be_nil
    end
  end
end
