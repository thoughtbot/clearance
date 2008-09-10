module GitCommands
  class ShellError < RuntimeError; end

  @logging = ENV['LOGGING'] != "false"

  def self.run cmd, *expected_exitstatuses
    puts "+ #{cmd}" if @logging
    output = `#{cmd} 2>&1`
    puts output.gsub(/^/, "- ") if @logging
    expected_exitstatuses << 0 if expected_exitstatuses.empty?
    raise ShellError.new("ERROR: '#{cmd}' failed with exit status #{$?.exitstatus}") unless 
      [expected_exitstatuses].flatten.include?( $?.exitstatus )
    output
  end

  def self.current_branch
    run("git branch --no-color | grep '*' | cut -d ' ' -f 2").chomp
  end

  def self.remote_branch_exists?(branch)
    ! run("git branch -r --no-color | grep '#{branch}'").blank?
  end

  def self.ensure_clean_working_directory!
    return if run("git status", 0, 1).match(/working directory clean/)
    raise "Must have clean working directory"
  end

  def self.diff_staging
    puts run("git diff HEAD origin/staging")
  end

  def self.diff_production
    puts run("git diff origin/staging origin/production")
  end

  def self.push_staging(branch)
    raise "Branch must not be blank" if branch.blank?
    raise "origin/staging branch does not exist" unless remote_branch_exists?("origin/staging")
    ensure_clean_working_directory!
    begin
      run "git fetch"
      run "git branch -f staging origin/staging"
      run "git checkout staging"
      run "git pull . #{branch}"
      run "git push origin staging"
    rescue
      puts "Creating staging tag failed."
      raise
    ensure
      run "git checkout master"
      run "git branch -D staging"
    end
  end

  def self.push_production
    raise "origin/production branch does not exist" unless remote_branch_exists?("origin/production")
    ensure_clean_working_directory!
    begin
      run "git fetch"
      run "git branch -f production origin/production"
      run "git checkout production"
      run "git pull origin staging"
      run "git push origin production"
    rescue
      puts "Creating production tag failed."
      raise
    ensure
      run "git checkout master"
      run "git branch -D production"
    end
  end

  def self.branch_production(branch)
    raise "Branch must not be blank" if branch.blank?
    ensure_clean_working_directory!
    run "git branch -f #{branch} origin/production"
    run "git checkout #{branch}"
  end

  def self.pull_template
    ensure_clean_working_directory!
    run "git pull git://github.com/thoughtbot/rails-template.git master"
  end
end

namespace :git do
  namespace :push do
    desc "Merge a branch into the origin/staging branch."
    task :staging do
      branch = ENV['BRANCH'].blank? ? GitCommands.current_branch : ENV['BRANCH']
      puts "Tagging #{branch} as origin/staging"
      GitCommands.push_staging(branch)
    end

    desc "Merge the staging branch into origin/production for launch."
    task :production => "diff:production" do
      GitCommands.push_production
    end
  end

  namespace :diff do
    desc "Show the difference between current branch and origin/staging."
    task :staging do
      GitCommands.diff_staging
    end

    desc "Show the difference between origin/staging and origin/production."
    task :production do
      GitCommands.diff_production
    end
  end

  namespace :pull do
    desc "Pull updates from the thoughtbot rails template"
    task :template do
      GitCommands.pull_template
    end
  end

  namespace :branch do
    desc "Branch origin/production into BRANCH locally."
    task :production do
      branch = ENV['BRANCH'].blank? ? GitCommands.current_branch : ENV['BRANCH']
      puts "Branching origin/production into #{branch}"
      GitCommands.branch_production(branch)
    end
  end
end
