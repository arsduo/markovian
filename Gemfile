source "https://rubygems.org"

# Specify your gem"s dependencies in markov-ahkoppel2.gemspec
gemspec

group :development, :test do
  gem "byebug", platform: :mri
  # If you're developing both gems, use the local version of Tokeneyes
  if File.exist?("../tokeneyes")
    gem "tokeneyes", path: "../tokeneyes"
  end
end

group :test do
  gem "rspec"
  gem "faker"
  gem "codeclimate-test-reporter"
end

