require "rdoc_rubocop/source_file"

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

      if file_paths.empty?
        report_zero
      else
        exit_code = run_cli(file_paths)
        targets.each(&:correct!)

        exit_code
      end
    end

    def style_check
      targets = source_files
      file_paths = targets.flat_map(&:source_code_file_paths)

      if file_paths.empty?
        report_zero
      else
        run_cli(file_paths)
      end
    end

    require "rdoc_rubocop/rubocop_modifier"
    include RDocRuboCop::RuboCopModifier::ConfigLoaderModifier

    def run_cli(source_code_file_paths)
      change_dotfilenames_temporary do
        @cli.run(@options + source_code_file_paths)
      end
    end

    def source_files
      @paths.map(&SourceFile.method(:build))
    end

    # Report with a message: "Inspecting 0 files"
    def report_zero
      non_existing_filepath = Dir.glob("#{__dir__}/*").sort.last.succ

      options, _ = RuboCop::Options.new.parse(@options)
      config_store = RuboCop::ConfigStore.new
      runner = RuboCop::Runner.new(options, config_store).run([non_existing_filepath])
    end
  end
end
