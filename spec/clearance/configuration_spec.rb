require "spec_helper"

describe Clearance::Configuration do
  describe "#url_after_sign_in" do
    it "defaults to /" do
      expect(Clearance.config.url_after_sign_in).to eq "/"
    end

    it "can be overridden" do
      with_config do
        Clearance.config.url_after_sign_in = "/foo"
        expect(Clearance.config.url_after_sign_in).to eq "/foo"
      end
    end
  end

  describe "#url_after_sign_out" do
    it "defaults to /" do
      expect(Clearance.config.url_after_sign_out).to eq "/"
    end

    it "can be overridden" do
      with_config do
        Clearance.config.url_after_sign_out = "/foo"
        expect(Clearance.config.url_after_sign_out).to eq "/foo"
      end
    end
  end

  describe "#url_after_sign_up" do
    it "defaults to /" do
      expect(Clearance.config.url_after_sign_up).to eq "/"
    end

    it "can be overridden" do
      with_config do
        Clearance.config.url_after_sign_up = "/foo"
        expect(Clearance.config.url_after_sign_up).to eq "/foo"
      end
    end
  end

  describe "#password_reset_class" do
    it "defaults to PasswordReset" do
      klass = Clearance.config.password_reset_class
      expect(klass).to eq PasswordReset
    end

    it "can be overridden" do
      with_config do
        resetter = double("password_resetter")
        Clearance.config.password_reset_class = resetter
        expect(Clearance.config.password_reset_class).to eq resetter
      end
    end
  end

  describe "#password_reset_mailer" do
    it "defaults to ClearanceMailer" do
      expect(Clearance.config.password_reset_mailer).to eq ClearanceMailer
    end

    it "can be overridden" do
      with_config do
        mailer = double("mailer")
        Clearance.config.password_reset_mailer = mailer
        expect(Clearance.config.password_reset_mailer).to eq mailer
      end
    end
  end

  describe "#mailer_sender" do
    it "defaults to reply@example.com" do
      expect(Clearance.config.mailer_sender).to eq "reply@example.com"
    end

    it "can be overridden" do
      with_config do
        sender = "sender"
        Clearance.config.mailer_sender = sender
        expect(Clearance.config.mailer_sender).to eq sender
      end
    end
  end

  describe "#user_param_key" do
    it "returns the parameter key for the configured user class" do
      expect(Clearance.config.user_param_key).to eq :user
    end
  end


  def with_config(&block)
    old_config = Clearance.config.dup
    yield
  ensure
    Clearance.config = old_config
  end
end
