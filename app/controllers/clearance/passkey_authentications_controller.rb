class Clearance::PasskeyAuthenticationsController < Clearance::BaseController
  skip_before_action :require_login, raise: false

  def new
    options = WebAuthn::Credential.options_for_get
    session[:passkey_authentication_challenge] = options.challenge

    render json: options
  end

  def create
    credential = WebAuthn::Credential.from_get(params)
    passkey = Clearance::Passkey.find_by!(external_id: credential.id)

    credential.verify(
      session.delete(:passkey_authentication_challenge),
      public_key: passkey.public_key,
      sign_count: passkey.sign_count
    )
    passkey.update!(sign_count: credential.sign_count)

    sign_in(passkey.user) do |status|
      if status.success?
        render json: {redirect_to: Clearance.configuration.redirect_url}
      else
        render json: {error: status.failure_message}, status: :unauthorized
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Passkey not found"}, status: :unauthorized
  rescue WebAuthn::Error => e
    render json: {error: e.message}, status: :unprocessable_content
  end
end
