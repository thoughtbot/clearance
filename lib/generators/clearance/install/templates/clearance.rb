Clearance.configure do |config|
  config.mailer_sender = 'reply@example.com'

  unless Rails.env.development? || Rails.env.test?
    config.secure_cookie = true
  end
end
