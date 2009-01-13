Rails::Generator::Commands::Create.class_eval do
  def rake_db_migrate
    logger.rake "db:migrate" 
    `rake db:migrate`   
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def rake_db_migrate
    logger.rake "db:migrate"    
  end
end

Rails::Generator::Commands::List.class_eval do
  def rake_db_migrate
    logger.rake "db:migrate"    
  end
end
