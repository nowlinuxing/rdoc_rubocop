require "optparse"

module RDocRuboCop
  class Options
    def initialize
      @options = {}
    end

    def parse(args)
      args = args.dup
      option_parser.parse!(args)
      [option_array, args]
    end

    def option_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: rdoc-rubocop [options] [file1, file2, ...]"

        opts.on("-a", "--auto-correct") { |arg| @options["--auto-correct"] = arg }
        opts.on("--auto-gen-config") { |arg| @options["--auto-gen-config"] = arg }
        opts.on("-d", "--debug") { |arg| @options["--debug"] = arg }

        opts.on("-c", "--config FILE") { |arg| @options["--config"] = arg }
        opts.on("--only COP1,COP2,...") { |arg| @options["--only"] = arg }
        opts.on("--except COP1,COP2,...") { |arg| @options["--except"] = arg }
      end
    end

    private

    def option_array
      @options.
        to_a.
        flat_map { |option, arg| arg.is_a?(String) ? [option, arg] : [option] }
    end
  end
end
