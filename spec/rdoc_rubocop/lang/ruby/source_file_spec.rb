require "spec_helper"

RSpec.describe RDocRuboCop::Lang::Ruby::SourceFile do
  describe "#correct" do
    let(:filename) { "path/to/dir/sample.rb" }
    let(:source) do
      <<-RUBY.strip_heredoc
        # comment
        #
        #   foo(1 , 2)
        #
        class Foo
          # foo
          #
          #   [1 , 2]
          #   each { |a , b| }
          #
        end
      RUBY
    end

    let(:source_file) { described_class.new(source, filename) }

    subject do
      source_file.source_code_file_paths[0].source = "foo(1, 2)\n"
      source_file.source_code_file_paths[1].source = <<-RUBY.strip_heredoc
        [1, 2]
        each { |a, b| }
      RUBY

      source_file.correct
    end

    it do
      expect { subject }.not_to raise_error
      expect(source_file.source).to eq(<<-CORRECTED.strip_heredoc)
        # comment
        #
        #   foo(1, 2)
        #
        class Foo
          # foo
          #
          #   [1, 2]
          #   each { |a, b| }
          #
        end
      CORRECTED
    end
  end
end
