class User < ActiveRecord::Base
  def previously_existed?
    true
  end
end
