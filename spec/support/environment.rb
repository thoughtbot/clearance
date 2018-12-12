module EnvironmentSupport
  def with_environment(replacement_env)
    original_env = ENV.to_hash
    ENV.update(replacement_env)

    begin
      yield
    ensure
      ENV.replace(original_env)
    end
  end
end
