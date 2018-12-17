require "spec_helper"

RSpec.describe RDocRuboCop::RuboCopModifier do
  describe "#run" do
    let(:file_path) do
      source_code = RDocRuboCop::Comment::SourceCode.new(
        [RDocRuboCop::Token::CommentToken.new([1, 1], :on_comment, "#   [1 , 2]\n", Ripper::EXPR_BEG)],
      )
      RDocRuboCop::FilePath.new("sample.rb", source_code)
    end
    let(:output) { StringIO.new }

    before do
      expect(RuboCop::Formatter::File).to receive(:open).with("output.txt", "w").and_return(output)
    end

    subject(:execute) do
      cli = RuboCop::CLI.new
      cli.run(options + [file_path])
    end

    let(:options) do
      options = [
        "--auto-correct",
        ["--only", "Layout/SpaceBeforeComma"],
        ["--format", "json"],
        ["--out", "output.txt"],
      ].flatten
    end

    it "should correct the source code" do
      expect { execute }.not_to raise_error
      expect(file_path.source).to eq("[1, 2]\n")
    end

    it "should output a report" do
      execute

      result = JSON.parse(output.string)
      expect(result.dig("summary", "inspected_file_count")).to eq(1)

      expect(result.dig("files", 0, "path")).to eq("sample.rb")
      expect(result.dig("files", 0, "offenses").size).to eq(1)
      expect(result.dig("files", 0, "offenses", 0)).to include(
        "cop_name"  => "Layout/SpaceBeforeComma",
        "corrected" => true,
      )
    end
  end
end
