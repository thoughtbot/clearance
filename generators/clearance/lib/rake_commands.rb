Rails::Generator::Commands::Create.class_eval do
  def rake_db_migrate
    logger.rake "db:migrate"
    unless system("rake db:migrate")
      logger.rake "db:migrate failed. Rolling back"      
      command(:destroy).invoke!
    end
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def rake_db_migrate
    logger.rake "db:rollback"  
    system "rake db:rollback"  
  end
end

Rails::Generator::Commands::List.class_eval do
  def rake_db_migrate
    logger.rake "db:migrate"    
  end
end
