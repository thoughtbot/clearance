class Clearance::PasskeysController < Clearance::BaseController
  before_action :require_login

  def new
    current_user.update_column(:webauthn_id, WebAuthn.generate_user_id) unless current_user.webauthn_id?

    options = WebAuthn::Credential.options_for_create(
      user: {id: current_user.webauthn_id, name: current_user.email}
    )
    session[:passkey_creation_challenge] = options.challenge

    render json: options
  end

  def create
    credential = WebAuthn::Credential.from_create(params)
    credential.verify(session.delete(:passkey_creation_challenge))

    current_user.passkeys.create!(
      label: params[:label],
      external_id: credential.id,
      public_key: credential.public_key,
      sign_count: credential.sign_count
    )

    head :created
  rescue WebAuthn::Error => e
    render json: {error: e.message}, status: :unprocessable_content
  end
end
