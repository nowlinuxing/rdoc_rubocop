require "spec_helper"

RSpec.describe RDocRuboCop::Lang::Ruby::Corrector do
  describe "#correct" do
    let(:source_file) { RDocRuboCop::Lang::Ruby::SourceFile.new(source, "path/to/dir/sample.rb") }

    let(:corrector) { described_class.new(source_file) }

    subject do
      corrector.correct
      corrector.corrected_source
    end

    context "when a comment contains a code" do
      let(:source) do
        <<-RUBY.strip_heredoc
          # comment
          #
          #   code1
          #   code2
          #
        RUBY
      end

      before do
        source_file.source_code_file_paths[0].source = <<-RUBY.strip_heredoc
          code1'
          code2'
        RUBY
      end

      it do
        expect(subject).to eq(<<-RUBY.strip_heredoc)
          # comment
          #
          #   code1'
          #   code2'
          #
        RUBY
      end
    end

    context "when there is a postfix comment for a line" do
      let(:source) do
        <<-RUBY.strip_heredoc
          def foo # :nodoc:
          end
        RUBY
      end

      it { expect(subject).to eq(source) }
    end

    context "when two comments are adjacent and the indent is different" do
      let(:source) do
        <<-RUBY
          def foo #:nodoc:
            # comment
          end
        RUBY
      end

      it { expect(subject).to eq(source) }
    end
  end
end
