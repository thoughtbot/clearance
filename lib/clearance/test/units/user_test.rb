module Clearance
  module UserTest
    
    def self.included(base)
      base.class_eval do
        should_require_attributes :email, :password

        should "require password validation on create" do
          user = Factory.build(:user, :password => 'blah', :password_confirmation => 'boogidy')
          assert !user.save
          assert_match(/confirmation/i, user.errors.on(:password))
        end

        should "create a crypted_password on save" do
          assert_not_nil Factory(:user, :crypted_password => nil).crypted_password
        end

        context 'updating a password' do
          setup do
            @user = Factory(:user)
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
            @password = 'sekrit'
            @salt = 'salt'
            User.any_instance.stubs(:initialize_salt)
            @user = Factory(:user, :password => @password, :salt => @salt)
          end
          
          should "require password validation on update" do
            @user.update_attributes(:password => "blah", :password_confirmation => "boogidy")
            assert !@user.save
            assert_match(/confirmation/i, @user.errors.on(:password))
          end
          
          should_require_unique_attributes :email
          
          context 'authenticating a user' do
            context 'with good credentials' do
              setup do
                @result = User.authenticate @user.email, 'sekrit'
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
              @expected = Digest::SHA1.hexdigest("--#{@salt}--#{@password}--")
            end

            should 'create a Hash using SHA1 encryption' do
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

      end
    end
  end
end
