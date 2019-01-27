require "spec_helper"

RSpec.describe RDocRuboCop::Lang::C::Comment do
  describe "#corrected_text" do
    let(:comment) { described_class.build(comment_text, "sample.c", 0, comment_text.length) }

    subject(:rdoc_text) { comment.rdoc.text }
    subject(:corrected_text) { comment.corrected_text }

    context "when a comment is composed only one line" do
      let(:comment_text) { "/* comment */" }

      it "should return a corrected text" do
        expect(rdoc_text).to eq("comment")
        expect(corrected_text).to eq(comment_text)
      end
    end

    context "when a comment contains a code" do
      let(:comment_text) do
        <<-CLANG.strip_heredoc.chomp
          /*
           * Document-class: Foo
           *
           *   code1
           *   code2
           */
        CLANG
      end

      it "should return a corrected text" do
        expect(rdoc_text).to eq(<<-CLANG.strip_heredoc.chomp)

          Document-class: Foo

            code1
            code2

        CLANG
        expect(corrected_text).to eq(comment_text)
      end
    end

    context "when the top of the comment are not empty" do
      let(:comment_text) do
        <<-CLANG.strip_heredoc.chomp
          /* Document-class: Foo
           *
           *   code
           */
        CLANG
      end

      it "should return a corrected text" do
        expect(rdoc_text).to eq(<<-CLANG.strip_heredoc.chomp)
          Document-class: Foo

            code

        CLANG
        expect(corrected_text).to eq(comment_text)
      end
    end

    context "when a comment contains consecutive asterisks" do
      let(:comment_text) do
        <<-CLANG.strip_heredoc.chomp
          /*****
           * Document-class: Foo
           *
           *   code
           *****/
        CLANG
      end

      it "should return a corrected text" do
        expect(rdoc_text).to eq(<<-CLANG.strip_heredoc)
          Document-class: Foo

            code
        CLANG
        expect(corrected_text).to eq(comment_text)
      end
    end

    context "when a comment contains only asterisks" do
      let(:comment_text) do
        <<-CLANG.strip_heredoc.chomp
          /*
           *
           */
        CLANG
      end

      it "should return a corrected text" do
        expect(rdoc_text).to eq("\n\n")
        expect(corrected_text).to eq(comment_text)
      end
    end

    context "when each line of comments does not have an asterisk at the beginning" do
      let(:comment_text) do
        <<-CLANG.strip_heredoc.chomp
          /*
           Document-class: Foo

             code
           */
        CLANG
      end

      it "should return a corrected text" do
        expect(rdoc_text).to eq(<<-CLANG.strip_heredoc)
          Document-class: Foo

            code
        CLANG
        expect(corrected_text).to eq(comment_text)
      end
    end
  end
end
