require "spec_helper"

describe "Backdoor Middleware" do
  it "allows signing in using query parameter" do
    user = create(:user)

    get root_path(as: user.to_param)

    expect(cookies["remember_token"]).to eq user.remember_token
  end

  it "removes the `as` param but leaves other parameters unchanged" do
    user = create(:user)

    get root_path(as: user.to_param, foo: 'bar')

    expect(response.body).to include('{"foo":"bar","controller":"application","action":"show"}')
  end
end
