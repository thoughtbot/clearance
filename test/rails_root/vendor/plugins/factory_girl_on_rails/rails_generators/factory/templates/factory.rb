Factory.define :<%= file_name %> do |<%= file_name %>|
<% for attribute in attributes -%>
  <%= factory_line(attribute) %>
<% end -%>
end
