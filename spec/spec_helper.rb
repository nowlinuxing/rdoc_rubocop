require "bundler/setup"
require "pry-byebug"
require "pry-doc"
require "rdoc_rubocop"

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

# When stub FIle.open
#
#   before do
#     expect(File).to receive(:open).with("output.txt", "w")
#   end
#
# and use binding.pry, raise a unexpected error:
#
#   it do
#     binding.pry
#     expect { subject }.not_to raise_error
#   end
#
#   #=> # #<File (class)> received :open with unexpected arguments
#           expected: ("output.txt", "w")
#                got: ("/home/user/.pry_history", "a", 123)
#
# To make easy to stub and debug, separate File is used in RuboCop from ::File.
class RuboCop::Formatter::File < File; end
