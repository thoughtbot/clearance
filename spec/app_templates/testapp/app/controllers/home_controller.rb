class HomeController < ApplicationController
  def show
    if Rails::VERSION::MAJOR >= 5
      render html: "", layout: "application"
    else
      render text: "", layout: "application"
    end
  end
end
