require 'byebug'
require 'fileutils'

def add_gems
  gem 'httparty'
  gem 'devise'
  gem 'id'

  gem_group :development do
    gem 'foreman'
  end

  gem_group :development, :test do
    gem 'awesome_print'
    gem 'rspec-rails'
    gem 'rubocop'
  end

  gem_group :test do
    gem 'database_cleaner'
    gem 'factory_bot_rails'
    gem 'shoulda-matchers'
    gem 'simplecov'
    gem 'timecop'
    gem 'vcr'
  end
end

def remove_comments_from_gemfile
  File.open('Gemfile_tmp', 'w') do |output_file|

    File.foreach('Gemfile') do |line|
      output_file.puts line unless line.include?('#') || line == "\n"
    end

  end

  FileUtils.mv('Gemfile_tmp', 'Gemfile')
end

def setup_spec
  generate "rspec:install"
end

def db_setup
  rails_command "db:create"
  rails_command "db:migrate"
end

def git_init
  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"
end

def remove_add_gitignore_lines
  File.open('.gitignore_tmp', 'w') do |output_file|

    File.foreach('.gitignore') do |line|
      output_file.puts line unless BLACKLISTED_LINES.include?(line)
    end

    GITIGNORE_LINES.each do |line|
      output_file.puts line
    end
  end

  FileUtils.mv('.gitignore_tmp', '.gitignore')
end

def create_spec_structure
  Dir.mkdir 'spec/shared_examples' unless File.exists?('spec/shared_examples')
  Dir.mkdir 'spec/cassettes' unless File.exists?('spec/cassettes')
  Dir.mkdir 'spec/stubs' unless File.exists?('spec/stubs')
end

 BLACKLISTED_LINES = [
   "/log/*\n",
   "/tmp/*\n",
   "!/log/.keep\n",
   "!/tmp/.keep\n",
   "/tmp/pids/*\n",
   "!/tmp/pids/\n",
   "!/tmp/pids/.keep\n",
   "\n"
  ]

 GITIGNORE_LINES = [
    "/log/*.log\n",
    "/tmp\n",
    "/vendor/bundle\n",
    "/db/*.sqlite3\n",
    ".DS_Store\n",
    "/coverage\n",
    "vendor/bundle\n",
    "vendor/cache\n",
    ".env.local"
 ]

remove_comments_from_gemfile
add_gems

after_bundle do
  remove_add_gitignore_lines
  #db_setup
  setup_spec
  create_spec_structure
  git_init
end
