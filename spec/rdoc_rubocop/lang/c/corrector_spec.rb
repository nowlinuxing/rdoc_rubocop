require "spec_helper"

RSpec.describe RDocRuboCop::Lang::C::Corrector do
  describe "#correct" do
    let(:source_file) { RDocRuboCop::Lang::C::SourceFile.new(source, "path/to/dir/sample.c") }

    let(:corrector) { described_class.new(source_file) }

    subject do
      corrector.correct
      corrector.corrected_source
    end

    context "when a comment contains a code" do
      let(:source) do
        <<-CLANG.strip_heredoc
          /*
           * Document-class: Foo
           *
           *   code1
           *   code2
           */
        CLANG
      end

      before do
        source_file.source_code_file_paths[0].source = <<-CLANG.strip_heredoc
          code1'
          code2'
        CLANG
      end

      it "should return a corrected text" do
        expect(subject).to eq(<<-CLANG.strip_heredoc)
          /*
           * Document-class: Foo
           *
           *   code1'
           *   code2'
           */
        CLANG
      end
    end

    context "when a comment contains consecutive asterisks" do
      let(:source) do
        <<-CLANG.strip_heredoc
          /*****
           * Document-class: Foo
           *
           *   code
           *****/
        CLANG
      end

      before do
        source_file.source_code_file_paths[0].source = "code'\n"
      end

      it "should return a corrected text" do
        expect(subject).to eq(<<-CLANG.strip_heredoc)
          /*****
           * Document-class: Foo
           *
           *   code'
           *****/
        CLANG
      end
    end
  end
end
