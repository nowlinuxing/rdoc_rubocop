require "spec_helper"

RSpec.describe RDocRuboCop::Lang::Ruby::Comment do
  describe "#source_codes" do
    def build_comment(locate, type, token, state)
      RDocRuboCop::Lang::Ruby::Token::CommentToken.new(locate, type, token, state)
    end

    let(:comment_tokens) do
      Ripper.
        lex(comment_text).
        select { |token| token[1] == :on_comment }.
        map { |token| build_comment(*token) }
    end

    subject { described_class.new(comment_tokens).source_codes }

    context "when CommentChunk has no code" do
      let(:comment_text) do
        <<-COMMENT.strip_heredoc
          # comment1
          # comment2
        COMMENT
      end

      it "should return an empty array" do
        expect(subject).to eq([])
      end
    end

    context "when CommentChunk has a code" do
      let(:comment_text) do
        <<-COMMENT.strip_heredoc
          # comment
          #
          #   code1
          #   code2
          #
        COMMENT
      end

      it "should return an array contains one instance of RubySnippet" do
        expect(subject.size).to eq(1)
        expect(subject[0]).to be_an_instance_of(RDocRuboCop::RDoc::RubySnippet)
        expect(subject[0].text).to eq(<<-RUBY.strip_indent)
          code1
          code2
        RUBY
      end
    end

    context "when CommentChunk has two code chunks" do
      let(:comment_text) do
        <<-COMMENT.strip_heredoc
          # comment
          #
          #   code1
          #
          # comment
          #
          #   code2
          #
        COMMENT
      end

      it "should return an array contains two instance of RubySnippet" do
        expect(subject.size).to eq(2)
        expect(subject[0].text).to eq("code1\n")
        expect(subject[1].text).to eq("code2\n")
      end
    end

    context "when the code has trailing blank lines" do
      let(:comment_text) do
        <<-COMMENT.strip_heredoc
          # comment
          #
          #   code1
          #   code2
          #
          #
        COMMENT
      end

      it "should return an array contains one instance of RubySnippet whose tailing blank lines is removed" do
        expect(subject.size).to eq(1)
        expect(subject[0].text).to eq(<<-RUBY.strip_indent)
          code1
          code2
        RUBY
      end
    end
  end
end
