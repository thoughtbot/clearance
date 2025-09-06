require "spec_helper"

Person = Class.new(User)

describe ClearanceMailer do
  it "is from DO_NOT_REPLY" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(Clearance.configuration.mailer_sender).to eq(email.from[0])
  end

  it "is sent to user" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.to.first).to eq(user.email)
  end

  it "sets its subject" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.subject).to include("Change your password")
  end

  it "has html and plain text parts" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.body.parts.length).to eq 2
    expect(email.text_part).to be_present
    expect(email.html_part).to be_present
  end

  it "contains a link to edit the password" do
    user = create(:user)
    user.forgot_password!
    host = ActionMailer::Base.default_url_options[:host]
    link = "http://#{host}/users/#{user.id}/password/edit" \
      "?token=#{user.confirmation_token}"

    email = ClearanceMailer.change_password(user)

    expect(email.text_part.body).to include(link)
    expect(email.html_part.body).to include(link)
    expect(email.html_part.body).to have_css(
      "a",
      text: I18n.t("clearance_mailer.change_password.link_text")
    )
  end

  context "when using a custom model" do
    it "contains a link for a custom model" do
      define_people_routes
      person = Person.new(email: "person@example.com", password: "password")

      person.forgot_password!
      host = ActionMailer::Base.default_url_options[:host]
      link = "http://#{host}/people/#{person.id}/password/edit" \
        "?token=#{person.confirmation_token}"

      email = ClearanceMailer.change_password(person)

      expect(email.text_part.body).to include(link)
      expect(email.html_part.body).to include(link)

      Object.send(:remove_const, :Person)
      Rails.application.reload_routes!
    end

    def define_people_routes
      Rails.application.routes.draw do
        resources :people, controller: "clearance/users", only: :create do
          resource(
            :password,
            controller: "clearance/passwords",
            only: %i[edit update]
          )
        end
      end
    end
  end
end
