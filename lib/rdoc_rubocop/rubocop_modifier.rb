require "rdoc_rubocop/file_path"

module RDocRuboCop
  module RuboCopModifier
    module HijackSTDIN
      def hijack_stdin_opt(filepath)
        if filepath.respond_to?(:source)
          stdin_backup = @options[:stdin]

          @options[:stdin] = filepath.source
          result = yield
          filepath.source = @options[:stdin]

          @options[:stdin] = stdin_backup

          result
        else
          yield
        end
      end
    end

    module RunnerModifier
      include HijackSTDIN

      def find_target_files(paths)
        file_paths, strs = paths.partition { |path| path.respond_to?(:source) }

        if file_paths.empty?
          super(strs)
        elsif strs.empty?
          file_paths
        else
          file_paths + super(strs)
        end
      end

      private

      def get_processed_source(file)
        hijack_stdin_opt(file) do
          super
        end
      end

      def cached_run?
        false
      end
    end

    module TeamModifier
      include HijackSTDIN

      def autocorrect(buffer, cops)
        hijack_stdin_opt(cops[0].processed_source.path) do
          super
        end
      end
    end
  end
end

RuboCop::Runner.prepend RDocRuboCop::RuboCopModifier::RunnerModifier
RuboCop::Cop::Team.prepend RDocRuboCop::RuboCopModifier::TeamModifier
