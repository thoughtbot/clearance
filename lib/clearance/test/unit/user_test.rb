module Clearance
  module Test
    module Unit
      module UserTest
    
        def self.included(unit_test)
          unit_test.class_eval do
            
            # registering
            
            context "When registering" do
              should_require_attributes        :email
              should_allow_values_for          :email, "foo@example.com"
              should_not_allow_values_for      :email, "foo"
              should_not_allow_values_for      :email, "example.com"
              
              should_validate_confirmation_of  :password, 
                :factory => :registered_user
              
              should "initialize salt" do
                assert_not_nil Factory(:registered_user).salt
              end
              
              context "encrypt password" do
                setup do
                  @salt = "salt"
                  User.any_instance.stubs(:initialize_salt)

                  @user     = Factory(:registered_user, :salt => @salt)
                  @password = @user.password

                  @user.encrypt(@password)
                  @expected = Digest::SHA512.hexdigest("--#{@salt}--#{@password}--")
                end

                should "create an encrypted password using SHA512 encryption" do
                  assert_equal     @expected, @user.encrypted_password
                  assert_not_equal @password, @user.encrypted_password
                end
              end
              
              should "store email in lower case" do
                user = Factory(:registered_user, :email => "John.Doe@example.com")
                assert_equal "john.doe@example.com", user.email
              end
            end
            
            context "When multiple users have registerd" do
              setup { @user = Factory(:registered_user) }
              
              should_require_unique_attributes :email
            end
            
            # confirming email
            
            context "A registered user without email confirmation" do
              setup do
                @user = Factory(:registered_user)
                assert ! @user.email_confirmed?
              end

              context "after #confirm_email!" do
                setup do
                  assert @user.confirm_email!
                  @user.reload
                end

                should "have confirmed their email" do
                  assert @user.email_confirmed?
                end
              end
            end
            
            # authenticating
        
            context "A user" do
              setup do
                @user     = Factory(:registered_user)
                @password = @user.password
              end
              
              should "authenticate with good credentials" do
                assert User.authenticate(@user.email, @password)
                assert @user.authenticated?(@password)
              end
              
              should "authenticate with good credentials, email in uppercase" do
                assert User.authenticate(@user.email.upcase, @password)
                assert @user.authenticated?(@password)
              end
              
              should "not authenticate with bad credentials" do
                assert ! User.authenticate(@user.email, 'horribly_wrong_password')
                assert ! @user.authenticated?('horribly_wrong_password')
              end
            end

            # remember me
            
            context "When registering with remember_me!" do
              setup do
                @user = Factory(:registered_user)
                assert_nil @user.remember_token
                assert_nil @user.remember_token_expires_at
                @user.remember_me!
              end

              should "set the remember token and expiration date" do
                assert_not_nil @user.remember_token
                assert_not_nil @user.remember_token_expires_at
              end
              
              should "remember user when token expires in the future" do
                @user.update_attribute :remember_token_expires_at, 
                  2.weeks.from_now.utc
                assert @user.remember?
              end

              should "not remember user when token has already expired" do
                @user.update_attribute :remember_token_expires_at, 
                  2.weeks.ago.utc
                assert ! @user.remember?
              end
              
              # logging out
              
              context "forget_me!" do
                setup { @user.forget_me! }

                should "unset the remember token and expiration date" do
                  assert_nil @user.remember_token
                  assert_nil @user.remember_token_expires_at
                end

                should "not remember user" do
                  assert ! @user.remember?
                end
              end
            end
            
            # updating password
            
            context "An email confirmed user" do
              setup { @user = Factory(:email_confirmed_user) }

              context "who changes and confirms password" do
                setup do
                  @user.password              = "new_password"
                  @user.password_confirmation = "new_password"
                  @user.save
                end

                should_change "@user.encrypted_password"
              end
            end
          
          end
        end

      end
    end
  end
end
