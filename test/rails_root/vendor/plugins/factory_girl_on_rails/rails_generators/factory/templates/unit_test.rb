require File.dirname(__FILE__) + '/../test_helper'

class <%= class_name %>Test < ActiveSupport::TestCase
<% for attribute in attributes -%>
  should_have_db_column :<%= attribute.name %>
<% end -%>
end
