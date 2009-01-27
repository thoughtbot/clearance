def path_to(page_name)
  case page_name
  
  when /the homepage/i
    root_path
    
  when /the signup page/i
    new_user_path
    
  when /the signin page/i
    new_session_path
  
  # Add more page name => path mappings here
  
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end
