require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :all

  should_have_many :posts
  should_have_many :dogs

  should_have_many :friendships
  should_have_many :friends

  should_have_one :address
  should_have_one :address, :dependent => :destroy

  should_have_indices :email, :name, [:email, :name]
  should_have_index :age

  should_have_named_scope :old,       :conditions => "age > 50"
  should_have_named_scope :eighteen,  :conditions => { :age => 18 }

  should_have_named_scope 'recent(5)',            :limit => 5
  should_have_named_scope 'recent(1)',            :limit => 1
  should_have_named_scope 'recent_via_method(7)', :limit => 7

  context "when given an instance variable" do
    setup { @count = 2 }
    should_have_named_scope 'recent(@count)', :limit => 2
  end

  should_not_allow_values_for :email, "blah", "b lah"
  should_allow_values_for :email, "a@b.com", "asdf@asdf.com"
  should_ensure_length_in_range :email, 1..100
  should_ensure_value_in_range :age, 1..100
  should_protect_attributes :password
  should_have_class_methods :find, :destroy
  should_have_instance_methods :email, :age, :email=, :valid?
  should_have_db_columns :name, :email, :age
  should_have_db_column :id, :type => "integer", :primary => true
  should_have_db_column :email, :type => "string", :default => nil,   :precision => nil, :limit    => 255,
                                :null => true,     :primary => false, :scale     => nil, :sql_type => 'varchar(255)'
  should_require_acceptance_of :eula
  should_require_unique_attributes :email, :scoped_to => :name

  should_ensure_length_is :ssn, 9, :message => "Social Security Number is not the right length"
  should_only_allow_numeric_values_for :ssn

  should_have_readonly_attributes :name

  should_fail do
    should_protect_attributes :name, :age
  end
end
