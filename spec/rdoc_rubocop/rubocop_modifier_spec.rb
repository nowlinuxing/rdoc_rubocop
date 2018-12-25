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

  describe RDocRuboCop::RuboCopModifier::ConfigLoaderModifier do
    describe "#change_dotfilenames_temporary" do
      subject do
        klass =
          Class.new do
            include RDocRuboCop::RuboCopModifier::ConfigLoaderModifier
          end

        klass.new.change_dotfilenames_temporary do
          [
            RuboCop::ConfigLoader::DOTFILE,
            RuboCop::ConfigLoader::AUTO_GENERATED_FILE,
          ]
        end
      end

      it "should change filenames" do
        is_expected.to eq([".rdoc_rubocop.yml", ".rdoc_rubocop_todo.yml"])
      end

      it "should restore original filenames" do
        subject
        expect(RuboCop::ConfigLoader::DOTFILE).to eq(".rubocop.yml")
        expect(RuboCop::ConfigLoader::AUTO_GENERATED_FILE).to eq(".rubocop_todo.yml")
      end
    end
  end
end
