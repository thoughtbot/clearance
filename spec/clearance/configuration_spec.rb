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

  def with_config(&block)
    old_config = Clearance.config.dup
    yield
  ensure
    Clearance.config = old_config
  end
end
