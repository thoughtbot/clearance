require 'spec_helper'

describe User do
  it { should have_db_index(:email) }
  it { should have_db_index(:remember_token) }

  describe 'when signing up' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to allow_value('foo@example.co.uk').for(:email) }
    it { is_expected.to allow_value('foo@example.com').for(:email) }
    it { is_expected.to allow_value('foo+bar@example.com').for(:email) }
    it { is_expected.not_to allow_value('foo@').for(:email) }
    it { is_expected.not_to allow_value('foo@example..com').for(:email) }
    it { is_expected.not_to allow_value('foo@.example.com').for(:email) }
    it { is_expected.not_to allow_value('foo').for(:email) }
    it { is_expected.not_to allow_value('example.com').for(:email) }
    it { is_expected.not_to allow_value('foo;@example.com').for(:email) }

    it 'stores email in down case and removes whitespace' do
      user = create(:user, email: 'Jo hn.Do e @exa mp le.c om')
      expect(user.email).to eq 'john.doe@example.com'
    end
  end

  describe 'when multiple users have signed up' do
    before { create(:user) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'a user' do
    before do
      @user = create(:user)
      @password = @user.password
    end

    it 'is authenticated with correct email and password' do
      expect(User.authenticate(@user.email, @password)).to eq(@user)
      expect(@user).to be_authenticated(@password)
    end

    it 'is authenticated with correct uppercased email and correct password' do
      expect(User.authenticate(@user.email.upcase, @password)).to eq(@user)
      expect(@user).to be_authenticated(@password)
    end

    it 'is not authenticated with incorrect credentials' do
      expect(User.authenticate(@user.email, 'bad_password')).to be_nil
      expect(@user).not_to be_authenticated('bad password')
    end

    it 'is retrieved via a case-insensitive search' do
      expect(User.find_by_normalized_email(@user.email.upcase)).to eq(@user)
    end
  end

  describe 'when resetting authentication with reset_remember_token!' do
    before do
      @user = create(:user)
      @user.remember_token = 'old-token'
      @user.reset_remember_token!
    end

    it 'changes the remember token' do
      expect(@user.remember_token).not_to eq 'old-token'
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
        expect(@user.encrypted_password).not_to eq @old_encrypted_password
      end
    end
  end

  it 'does not generate same remember token for users with same password at same time' do
    allow(Time).to receive(:now).and_return(Time.now)
    password = 'secret'
    first_user = create(:user, password: password)
    second_user = create(:user, password: password)
    expect(second_user.remember_token).not_to eq first_user.remember_token
  end

  describe 'a user' do
    before do
      @user = create(:user)
      @old_encrypted_password = @user.encrypted_password
    end

    describe 'who requests password reminder' do
      before do
        expect(@user.confirmation_token).to be_nil
        @user.forgot_password!
      end

      it 'generates confirmation token' do
        expect(@user.confirmation_token).not_to be_nil
      end

      describe 'and then updates password' do
        describe 'with password' do
          before do
            @user.update_password 'new_password'
          end

          it 'changes encrypted password' do
            expect(@user.encrypted_password).not_to eq @old_encrypted_password
          end

          it 'clears confirmation token' do
            expect(@user.confirmation_token).to be_nil
          end
        end

        describe 'with blank password' do
          before do
            @user.update_password ''
          end

          it 'does not change encrypted password' do
            expect(@user.encrypted_password.to_s).to eq @old_encrypted_password
          end

          it 'does not clear confirmation token' do
            expect(@user.confirmation_token).to_not be_nil
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

    it { is_expected.to allow_value(nil).for(:email) }
    it { is_expected.to allow_value('').for(:email) }
  end

  describe 'user factory' do
    it 'should create a valid user with just an overridden password' do
      expect(build(:user, password: 'test')).to be_valid
    end
  end

  describe 'email address normalization' do
    let(:email) { 'Jo hn.Do e @exa mp le.c om' }

    it 'downcases the address and strips spaces' do
      expect(User.normalize_email(email)).to eq 'john.doe@example.com'
    end
  end

  describe 'the password setter on a User' do
    let(:password) { 'a-password' }
    before { subject.send(:password=, password) }

    it 'sets password to the plain-text password' do
      expect(subject.password).to eq password
    end

    it 'also sets encrypted_password' do
      expect(subject.encrypted_password).to_not be_nil
    end
  end
end

describe UserWithOptionalPassword do
  it { is_expected.to allow_value(nil).for(:password) }
  it { is_expected.to allow_value('').for(:password) }

  it 'cannot authenticate with blank password' do
    user = create(:user_with_optional_password)

    expect(UserWithOptionalPassword.authenticate(user.email, '')).to be_nil
  end
end
