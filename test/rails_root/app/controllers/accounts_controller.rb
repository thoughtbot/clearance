class AccountsController < ApplicationController
   before_filter :authenticate

   def edit
   end

   def create
     redirect_to edit_account_path
   end
end
