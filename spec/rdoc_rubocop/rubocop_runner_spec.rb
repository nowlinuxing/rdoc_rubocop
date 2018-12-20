require "spec_helper"

RSpec.describe RDocRuboCop::RuboCopRunner do
  describe "#run" do
    let(:filename) { "path/to/dir/sample.rb" }
    let(:code) do
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
    let(:output) { StringIO.new }

    before do
      expect(RuboCop::Formatter::File).to receive(:open).with("output.txt", "w").and_return(output)
      expect(File).to receive(:open).with("path/to/dir/sample.rb", "r").and_return(StringIO.new(code))
    end

    subject(:run) do
      runner = described_class.new([filename], options: options)
      runner.run
    end

    context "when auto correct option is specified" do
      let(:options) do
        [
          ["--auto-correct"],
          ["--only", "Layout/SpaceBeforeComma"],
          ["--format", "json"],
          ["--out", "output.txt"],
        ].flatten
      end

      let(:corrected_source) { StringIO.new }

      before do
        expect(File).to receive(:open).with("path/to/dir/sample.rb", "w").and_yield(corrected_source)
      end

      it "should correct specified file" do
        expect { run }.not_to raise_error

        expect(corrected_source.string).to eq(<<-RUBY.strip_heredoc)
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
        RUBY
      end

      it "should output corrected report" do
        run

        result = JSON.parse(output.string)
        expect(result.dig("summary", "inspected_file_count")).to eq(2)

        expect(result.dig("files", 0, "path")).to eq("path/to/dir/sample.rb")
        expect(result.dig("files", 0, "offenses").size).to eq(1)
        expect(result.dig("files", 0, "offenses", 0)).to include(
          "cop_name"  => "Layout/SpaceBeforeComma",
          "corrected" => true,
        )

        expect(result.dig("files", 1, "path")).to eq("path/to/dir/sample.rb")
        expect(result.dig("files", 1, "offenses").size).to eq(2)
        expect(result.dig("files", 1, "offenses", 0)).to include(
          "cop_name"  => "Layout/SpaceBeforeComma",
          "corrected" => true,
        )
      end
    end

    context "when auto correct option is not specified" do
      let(:options) do
        [
          ["--only", "Layout/SpaceBeforeComma"],
          ["--format", "json"],
          ["--out", "output.txt"],
        ].flatten
      end

      it "should output corrected report" do
        expect { run }.not_to raise_error

        result = JSON.parse(output.string)
        expect(result.dig("summary", "inspected_file_count")).to eq(2)

        expect(result.dig("files", 0, "path")).to eq("path/to/dir/sample.rb")
        expect(result.dig("files", 0, "offenses").size).to eq(1)
        expect(result.dig("files", 0, "offenses", 0)).to include(
          "cop_name"  => "Layout/SpaceBeforeComma",
          "corrected" => false,
        )

        expect(result.dig("files", 1, "path")).to eq("path/to/dir/sample.rb")
        expect(result.dig("files", 1, "offenses").size).to eq(2)
        expect(result.dig("files", 1, "offenses", 0)).to include(
          "cop_name"  => "Layout/SpaceBeforeComma",
          "corrected" => false,
        )
      end
    end
  end
end
