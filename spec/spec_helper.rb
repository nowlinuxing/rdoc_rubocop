require "bundler/setup"
require "rdoc_rubocop"
require "pry-byebug"
require "pry-doc"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class String
  # Simplified version of ActiveSupport
  # activesupport/lib/active_support/core_ext/string/strip.rb
  def strip_heredoc
    gsub(/^#{scan(/^ *(?=\S)/).min}/, "")
  end
end
