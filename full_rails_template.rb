require 'byebug'
def add_gems
  add_source 'https://rubygems.org' do
    gem 'httparty'
    gem 'id'

    gem_group :development do
      gem 'foreman'
    end

    gem_group :development, :test do
      gem 'rspec-rails'
      gem 'rubocop'
      gem 'awesome_print'
    end

    gem_group :test do
      gem 'database_cleaner', '~> 1.7'
      gem 'factory_bot_rails'
      gem 'shoulda-matchers'
      gem 'simplecov'
      gem 'timecop'
      gem 'vcr'
    end
  end
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
  #git commit: "-a -m 'Initial commit'"
end

def add_git_ignore
  inject_into_file(
    '.gitignore',
    "/log/*.log\n
    /tmp\n
    /vendor/bundle"
  )
end

def remove_lines
  file = File.open('.gitignore', 'r+')
  byebug
  file.delete('/log/*')
  file.delete('/tmp/*')
  file.delete('!/log/.keep')
  file.delete('!/tmp/.keep')
  file.close
end

add_gems

after_bundle do
  add_git_ignore
  remove_lines
  #db_setup
  #setup_spec
  #git_init
end
