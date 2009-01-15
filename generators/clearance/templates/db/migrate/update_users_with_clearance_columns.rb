class CreateOrUpdateUsersWithClearanceColumns < ActiveRecord::Migration
  def self.up
<% 
      existing_columns = ActiveRecord::Base.connection.columns(:users).map { |column| column.name }
      columns = [
        [:email,                     't.string :email'],
        [:crypted_password,          't.string :crypted_password, :limit => 40'],
        [:salt,                      't.string :salt, :limit => 40'],
        [:remember_token,            't.string :remember_token'],
        [:remember_token_expires_at, 't.datetime :remember_token_expires_at'],
        [:confirmed,                 't.boolean :confirmed, :default => false, :null => false']
      ].delete_if {|c| existing_columns.include?(c.first.to_s)} 
-%>
    change_table(:users) do |t|
<% columns.each do |c| -%>
      <%= c.last %>
<% end -%>
    end
    
<%
    existing_indexes = ActiveRecord::Base.connection.indexes(:users).map { |index| index.name }
    indexes = [
      [:index_users_on_email_and_crypted_password, 'add_index :users, [:email, :crypted_password]'],
      [:index_users_on_id_and_salt,                'add_index :users, [:id, :salt]'],
      [:index_users_on_email,                      'add_index :users, :email'],
      [:index_users_on_remember_token,             'add_index :users, :remember_token']
    ].delete_if {|i| existing_indexes.include?(i.first.to_s)}
-%>
<% indexes.each do |i| -%>
    <%= i.last %>
<% end -%>
  end
  
  def self.down
    change_table(:users) do |t|
<% unless columns.empty? -%>
      t.remove <%= columns.collect {|c| ":#{c.first}" }.join(',') %>
<% end -%>
    end
  end
end
