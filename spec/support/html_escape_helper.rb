module HTMLEscapeHelper
  def translated_string(key)
    if [7.0].include?(Rails::VERSION::STRING.to_f)
      ERB::Util.html_escape_once(I18n.t(key))
    else
      I18n.t(key)
    end
  end
end

RSpec.configure do |config|
  config.include HTMLEscapeHelper
end
