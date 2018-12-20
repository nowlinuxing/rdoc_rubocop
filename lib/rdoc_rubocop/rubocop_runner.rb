require "rdoc_rubocop/source_file"
require "rdoc_rubocop/comment_extractor"

module RDocRuboCop
  class RuboCopRunner
    def initialize(paths = [], options: [])
      @paths = paths
      @options = options
      @cli = RuboCop::CLI.new
    end

    def run
      if @options.include?("-a") || @options.include?("--auto-correct")
        format
      else
        style_check
      end
    end

    private

    def format
      targets = source_files

      file_paths = targets.flat_map(&:source_code_file_paths)
      exit_code = run_cli(file_paths)

      targets.each(&:correct!)

      exit_code
    end

    def style_check
      targets = source_files
      file_paths = targets.flat_map(&:source_code_file_paths)
      run_cli(file_paths)
    end

    def run_cli(source_code_file_paths)
      @cli.run(@options + source_code_file_paths)
    end

    def source_files
      @paths.map(&SourceFile.method(:build))
    end
  end
end
