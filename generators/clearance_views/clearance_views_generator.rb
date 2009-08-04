class ClearanceViewsGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      strategy          = "formtastic"
      template_strategy = "erb"

      m.directory File.join("app", "views", "users")
      m.file "#{strategy}/users/new.html.#{template_strategy}",
        "app/views/users/new.html.#{template_strategy}"
      m.file "#{strategy}/users/_inputs.html.#{template_strategy}",
        "app/views/users/_inputs.html.#{template_strategy}"

      m.directory File.join("app", "views", "sessions")
      m.file "#{strategy}/sessions/new.html.#{template_strategy}",
        "app/views/sessions/new.html.#{template_strategy}"

      m.directory File.join("app", "views", "passwords")
      m.file "#{strategy}/passwords/new.html.#{template_strategy}",
        "app/views/passwords/new.html.#{template_strategy}"
      m.file "#{strategy}/passwords/edit.html.#{template_strategy}",
        "app/views/passwords/edit.html.#{template_strategy}"
    end
  end

end

