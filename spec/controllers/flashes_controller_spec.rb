require 'spec_helper'

class FlashesController < ActionController::Base
  include Clearance::Authentication

  def set_flash
    flash[:notice] = params[:message]
    redirect_to view_flash_url
  end

  def view_flash
    render :text => "<html><body>#{flash[:notice]}</body></html>"
  end
end

describe FlashesController do
  before do
    Rails.application.routes.draw do
      match 'set_flash' => 'flashes#set_flash'
      match 'view_flash' => 'flashes#view_flash'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  it 'sets and views a flash' do
    visit '/set_flash?message=hello'
    page.should have_content('hello')
  end
end
