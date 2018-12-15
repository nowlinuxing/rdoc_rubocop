require "spec_helper"

RSpec.describe RDocRuboCop::Comment do
  describe "#source_codes" do
    def build_comment(locate, type, token, state)
      RDocRuboCop::Token::CommentToken.new(locate, type, token, state)
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

      it "should return an array contains one instance of SourceCode" do
        expect(subject.size).to eq(1)
        expect(subject[0]).to be_an_instance_of(RDocRuboCop::Comment::SourceCode)
        expect(subject[0].comment_tokens.size).to eq(2)
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

      it "should return an array contains two instance of SourceCode" do
        expect(subject.size).to eq(2)
        expect(subject[0].comment_tokens.size).to eq(1)
        expect(subject[1].comment_tokens.size).to eq(1)
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

      it "should return an array contains one instance of SourceCode whose tailing blank lines is removed" do
        expect(subject.size).to eq(1)
        expect(subject[0].comment_tokens.size).to eq(2)
      end
    end
  end
end
