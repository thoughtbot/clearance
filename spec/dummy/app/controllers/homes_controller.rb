class HomesController < ApplicationController
  def index
    if signed_in?
      render text: 'signed in'
    else
      render text: 'GUEST'
    end
  end
end
