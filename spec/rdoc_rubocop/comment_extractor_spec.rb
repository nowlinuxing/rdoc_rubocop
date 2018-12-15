require "spec_helper"

RSpec.describe RDocRuboCop::CommentExtractor do
  describe "#extract" do
    let(:source) do
      <<-RUBY.strip_heredoc
        # comment1-1
        # comment1-2
        # comment1-3

        class Foo
          # comment-in-Foo-1
          # comment-in-Foo-2
          # comment-in-Foo-3
          def foo
            "foo"
          end
          module_function :foo
        end
      RUBY
    end
    let(:source_file) { RDocRuboCop::SourceFile.new(source, "foo.rb") }

    subject { described_class.new(source_file).extract }

    it do
      expect(subject.size).to eq(2)

      expect(subject[0].comment_tokens[0]).to be_an_instance_of(RDocRuboCop::Token::CommentToken)
      expect(subject[0].comment_tokens[0].lineno).to eq(1)
      expect(subject[0].comment_tokens[0].token).to eq("# comment1-1\n")
      expect(subject[0].comment_tokens[1]).to be_an_instance_of(RDocRuboCop::Token::CommentToken)
      expect(subject[0].comment_tokens[1].lineno).to eq(2)
      expect(subject[0].comment_tokens[1].token).to eq("# comment1-2\n")
      expect(subject[0].comment_tokens[2]).to be_an_instance_of(RDocRuboCop::Token::CommentToken)
      expect(subject[0].comment_tokens[2].lineno).to eq(3)
      expect(subject[0].comment_tokens[2].token).to eq("# comment1-3\n")

      expect(subject[1].comment_tokens[0]).to be_an_instance_of(RDocRuboCop::Token::CommentToken)
      expect(subject[1].comment_tokens[0].lineno).to eq(6)
      expect(subject[1].comment_tokens[0].token).to eq("# comment-in-Foo-1\n")
      expect(subject[1].comment_tokens[1]).to be_an_instance_of(RDocRuboCop::Token::CommentToken)
      expect(subject[1].comment_tokens[1].lineno).to eq(7)
      expect(subject[1].comment_tokens[1].token).to eq("# comment-in-Foo-2\n")
      expect(subject[1].comment_tokens[2]).to be_an_instance_of(RDocRuboCop::Token::CommentToken)
      expect(subject[1].comment_tokens[2].lineno).to eq(8)
      expect(subject[1].comment_tokens[2].token).to eq("# comment-in-Foo-3\n")
    end
  end
end
