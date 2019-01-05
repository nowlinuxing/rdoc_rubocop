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

    module ConfigLoaderModifier
      DOTFILE = ".rdoc_rubocop.yml".freeze
      AUTO_GENERATED_FILE = ".rdoc_rubocop_todo.yml".freeze

      def change_dotfilenames_temporary
        dotfile_backup = RuboCop::ConfigLoader::DOTFILE
        auto_generated_file_backup = RuboCop::ConfigLoader::AUTO_GENERATED_FILE

        redefine_const(:DOTFILE, DOTFILE)
        redefine_const(:AUTO_GENERATED_FILE, AUTO_GENERATED_FILE)

        yield
      ensure
        redefine_const(:DOTFILE, dotfile_backup)
        redefine_const(:AUTO_GENERATED_FILE, auto_generated_file_backup)
      end

      private

      def redefine_const(const_name, value)
        RuboCop::ConfigLoader.send(:remove_const, const_name)
        RuboCop::ConfigLoader.const_set(const_name, value)
      end
    end
  end
end

RuboCop::Runner.prepend RDocRuboCop::RuboCopModifier::RunnerModifier
RuboCop::Cop::Team.prepend RDocRuboCop::RuboCopModifier::TeamModifier
