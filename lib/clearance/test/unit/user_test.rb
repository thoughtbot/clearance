module Clearance
  module Test
    module Unit
      module UserTest
    
        def self.included(unit_test)
          unit_test.class_eval do
            
            context "a User" do
              setup { @user = Factory(:clearance_user) }

              should_require_attributes        :email
              should_require_unique_attributes :email
              should_allow_values_for          :email, "foo@example.com"
              should_not_allow_values_for      :email, "foo"
              should_not_allow_values_for      :email, "example.com"
            end
            
            # registering
            # not confirming password
            # confirming account
            # remember me
            # forget me
            # recovering password
            # updating password
            
            context "password is confirmed but encrypted_password is blank" do
              setup do
                @user = Factory(:clearance_user, :encrypted_password => nil)
              end

              should "encrypt password" do
                assert_not_nil @user.encrypted_password
              end
            end
            
            context "password is not confirmed on create" do
              setup do
                @user = Factory.build(:clearance_user, 
                          :password              => "password", 
                          :password_confirmation => "unconfirmed_password")
                assert ! @user.save
              end

              should "raise error on password" do
                assert_match(/confirmation/i, @user.errors.on(:password))
              end
            end
            
            context "password is not confirmed on update" do
              setup do
                @user = Factory(:clearance_user)
                @user.update_attributes(
                  :password              => "password", 
                  :password_confirmation => "unconfirmed_password")
              end

              should "raise error on password" do
                assert_match(/confirmation/i, @user.errors.on(:password))
              end
            end
            
            context "An existing User" do
              setup { @user = Factory(:clearance_user) }

              context "who changes and confirms password" do
                setup do
                  @user.password              = "new_password"
                  @user.password_confirmation = "new_password"
                  @user.save
                end

                should_change "@user.encrypted_password"
              end
            end
        
            context "A user" do
              setup do
                @salt = "salt"
                User.any_instance.stubs(:initialize_salt)
                
                @user     = Factory(:clearance_user, :salt => @salt)
                @password = @user.password
              end
              
              should "store email in lower case" do
                @user.update_attributes(:email => 'John.Doe@example.com')
                assert_equal 'john.doe@example.com', @user.email
              end
              
              should "authenticate with good credentials" do
                assert User.authenticate(@user.email, @password)
              end
              
              should "authenticate with good credentials, email in uppercase" do
                assert User.authenticate(@user.email.upcase, @password)
              end
              
              should "not authenticate with bad credentials" do
                assert ! User.authenticate(@user.email, 'horribly_wrong_password')
              end
              
              should "be authenticated with a good password" do
                assert @user.authenticated?(@password)
              end
              
              should "not be authenticated with a bad password" do
                assert ! @user.authenticated?('horribly_wrong_password')
              end
            end

            context "remember_me!" do
              setup do
                @user = Factory(:clearance_user)
                assert_nil @user.remember_token
                assert_nil @user.remember_token_expires_at
                @user.remember_me!
              end

              should "set the remember token and expiration date" do
                assert_not_nil @user.remember_token
                assert_not_nil @user.remember_token_expires_at
              end

              should "have an unexpired remember_token" do
                assert @user.remember?
              end
              
              should "remember user when token expires in the future" do
                @user.update_attribute :remember_token_expires_at, 2.weeks.from_now.utc
                assert @user.remember?
              end

              should "not remember user when token has already expired" do
                @user.update_attribute :remember_token_expires_at, 2.weeks.ago.utc
                assert ! @user.remember?
              end

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

            context "encrypt the user's password" do
              setup do
                @salt = "salt"
                User.any_instance.stubs(:initialize_salt)
                
                @user     = Factory(:clearance_user, :salt => @salt)
                @password = @user.password
                
                @user.encrypt(@password)
                @expected = Digest::SHA512.hexdigest("--#{@salt}--#{@password}--")
              end

              should "create an encrypted password using SHA512 encryption" do
                assert_equal     @expected, @user.encrypted_password
                assert_not_equal @password, @user.encrypted_password
              end
            end
            
            context "An unconfirmed user" do
              setup do
                @user = Factory(:clearance_user)
                assert ! @user.confirmed?
              end

              context "after #confirm!" do
                setup do
                  assert @user.confirm!
                  @user.reload
                end

                should "be confirmed" do
                  assert @user.confirmed?
                end
              end
            end
          
          end
        end

      end
    end
  end
end
