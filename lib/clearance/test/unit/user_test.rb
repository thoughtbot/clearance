module Clearance
  module Test
    module Unit
      module UserTest
    
        def self.included(base)
          base.class_eval do
            should_require_attributes :email, :password
            should_allow_values_for :email, 'foo@example.com'
            should_not_allow_values_for :email, 'foo'
            should_not_allow_values_for :email, 'example.com'

            should "require password validation on create" do
              user = Factory.build(:clearance_user, :password => 'blah', :password_confirmation => 'boogidy')
              assert !user.save
              assert_match(/confirmation/i, user.errors.on(:password))
            end

            should "create a crypted_password on save" do
              assert_not_nil Factory(:clearance_user, :crypted_password => nil).crypted_password
            end

            context 'updating a password' do
              setup do
                @user = Factory(:clearance_user)
                assert_not_nil @user.crypted_password
                @crypt = @user.crypted_password
                assert_not_nil @user.salt
                @salt = @user.salt
                @user.password = 'a_new_password'
                @user.password_confirmation = 'a_new_password'
                assert @user.save
              end

              should 'update a crypted_password' do
                @user.reload
                assert @user.crypted_password != @crypt
              end
            end
        
            context 'A user' do
              setup do
                @salt = 'salt'
                User.any_instance.stubs(:initialize_salt)
                @user = Factory :clearance_user, :salt => @salt
                @password = @user.password
              end
          
              should "require password validation on update" do
                @user.update_attributes(:password => "blah", :password_confirmation => "boogidy")
                assert !@user.save
                assert_match(/confirmation/i, @user.errors.on(:password))
              end
          
              should_require_unique_attributes :email
              
              should 'store email in lower case' do
                @user.update_attributes(:email => 'John.Doe@example.com')
                assert_equal 'john.doe@example.com', @user.email
              end
          
              context 'authenticating a user' do
                context 'with good credentials' do
                  setup do
                    @result = User.authenticate @user.email, @password
                  end

                  should 'return true' do
                    assert @result
                  end
                end
                
                context 'with an email in upper case and a good password' do
                  setup do
                    @result = User.authenticate @user.email.upcase, @password
                  end

                  should 'return true' do
                    assert @result
                  end
                end                

                context 'with bad credentials' do
                  setup do
                    @result = User.authenticate @user.email, 'horribly_wrong_password'
                  end

                  should 'return false' do
                    assert !@result
                  end
                end
              end
          
              context 'authenticated?' do
                context 'with good credentials' do
                  setup do
                    @result = @user.authenticated? @password
                  end

                  should 'return true' do
                    assert @result
                  end
                end

                context 'with bad credentials' do
                  setup do
                    @result = @user.authenticated? 'horribly_wrong_password'
                  end

                  should 'return false' do
                    assert !@result
                  end
                end
              end

              context 'encrypt' do
                setup do
                  @crypted  = @user.encrypt(@password)
                  @expected = Digest::SHA512.hexdigest("--#{@salt}--#{@password}--")
                end

                should 'create a Hash using SHA512 encryption' do
                  assert_equal @expected, @crypted
                  assert_not_equal @password, @crypted
                end
              end

              context 'remember_me!' do
                setup do
                  assert_nil @user.remember_token
                  assert_nil @user.remember_token_expires_at
                  @user.remember_me!
                end

                should 'set the remember token and expiration date' do
                  assert_not_nil @user.remember_token
                  assert_not_nil @user.remember_token_expires_at
                end

                should 'remember_token?' do
                  assert @user.remember_token?
                end

                context 'forget_me!' do
                  setup do
                    @user.forget_me!
                  end

                  should 'unset the remember token and expiration date' do
                    assert_nil @user.remember_token
                    assert_nil @user.remember_token_expires_at
                  end

                  should 'not remember_token?' do
                    assert ! @user.remember_token?
                  end
                end
              end

              context 'remember_token?' do
                context 'when token expires in the future' do
                  setup do
                    @user.update_attribute :remember_token_expires_at, 2.weeks.from_now.utc
                  end

                  should 'be true' do
                    assert @user.remember_token?
                  end
                end

                context 'when token expired' do
                  setup do
                    @user.update_attribute :remember_token_expires_at, 2.weeks.ago.utc
                  end

                  should 'be false' do
                    assert ! @user.remember_token?
                  end
                end
              end

              context "User.authenticate with a valid email and password" do
                setup do
                  @found_user = User.authenticate @user.email, @user.password
                end

                should "find that user" do
                  assert_equal @user, @found_user
                end
              end

              context "When sent authenticate with an invalid email and password" do
                setup do
                  @found_user = User.authenticate "not", "valid" 
                end

                should "find nothing" do
                  assert_nil @found_user
                end
              end
            end

            context "A user" do
              setup do
                @user = Factory :clearance_user
              end

              context 'when sent #confirm!' do
                setup do
                  assert ! @user.confirmed?
                  assert @user.confirm!
                  @user.reload
                end

                should 'mark the User record as confirmed' do
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
