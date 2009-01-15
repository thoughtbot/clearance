module Clearance
  module Test
    module Unit
      module ClearanceMailerTest
  
        def self.included(base)
          base.class_eval do
            context "A change password email" do
              setup do
                @user = Factory :clearance_user
                @email = ClearanceMailer.create_change_password @user
              end

              should "set its from address to DO_NOT_REPLY" do
                assert_equal DO_NOT_REPLY, @email.from[0]
              end

              should "contain a link to edit the user's password" do
                host = ActionMailer::Base.default_url_options[:host]
                regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?email=#{@user.email.gsub("@", "%40")}&amp;password=#{@user.crypted_password}}
                assert_match regexp, @email.body
              end

              should "be sent to the user" do
                assert_equal [@user.email], @email.to
              end

              should "set its subject" do
                assert_match /Change your password/, @email.subject
              end
            end
            
            context "A confirmation email" do
              setup do
                @user = Factory :clearance_user
                @email = ClearanceMailer.create_confirmation @user
              end

              should 'set its recipient to the given user' do
                assert_equal @user.email, @email.to[0]
              end

              should 'set its subject' do
                assert_match /Account confirmation/, @email.subject
              end

              should 'set its from address to DO_NOT_REPLY' do
                assert_equal DO_NOT_REPLY, @email.from[0]
              end

              should "contain a link to confirm the user's account" do
                host = ActionMailer::Base.default_url_options[:host]
                regexp = %r{http://#{host}/users/#{@user.id}/confirmation/new\?salt=#{@user.salt}}
                assert_match regexp, @email.body
              end
            end
          end
        end

      end
    end  
  end
end
