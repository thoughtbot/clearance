require "spec_helper"

describe "Authentication cookie" do
  it "is not returned if the request does not authenticate" do
    user = create(:user, password: "password")

    post session_path, session: { email: user.email, password: "password" }

    get static_endpoint_path
    expect(headers["Set-Cookie"]).to be_nil
  end

  it "is returned if the request does authentication" do
    user = create(:user, password: "password")

    post session_path, session: { email: user.email, password: "password" }

    get static_endpoint_path(use_current_user: true)
    expect(headers["Set-Cookie"]).to match(/remember_token=/)
  end
end
