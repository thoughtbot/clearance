<%
  existing_columns = ActiveRecord::Base.connection.columns(:users).map(&:name)
  new_columns = {
    :email => 't.string :email',
    :encrypted_password => 't.string :encrypted_password, :limit => 128',
    :confirmation_token => 't.string :confirmation_token, :limit => 128',
    :remember_token => 't.string :remember_token, :limit => 128'
  }.reject { |column| existing_columns.include?(column.to_s) }
-%>
<%
  existing_indexes = ActiveRecord::Base.connection.indexes(:users).map(&:name)
  new_indexes = {
    :index_users_on_email => 'add_index :users, :email',
    :index_users_on_remember_token => 'add_index :users, :remember_token'
  }.reject { |index| existing_indexes.include?(index.to_s) }
-%>
class UpgradeClearanceToDiesel < ActiveRecord::Migration
  def self.up
    change_table :users  do |t|
<% new_columns.values.each do |column| -%>
      <%= column %>
<% end -%>
    end

<% new_indexes.values.each do |index| -%>
    <%= index %>
<% end -%>
  end

  def self.down
    change_table :users do |t|
<% if new_columns.any? -%>
      t.remove <%= new_columns.keys.map { |column| ":#{column}" }.join(',') %>
<% end -%>
    end
  end
end
