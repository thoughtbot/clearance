class UserWithOptionalPassword < User
  private

  def password_optional?
    true
  end
end
