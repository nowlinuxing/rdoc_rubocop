require "rdoc_rubocop/indent_util"
require "rdoc_rubocop/rdoc/line"
require "rdoc_rubocop/file_path"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  class RDoc
    class RubySnippet
      attr_reader :file_path

      def initialize
        @lines = []
      end

      def append(line)
        @lines << line
      end

      def empty?
        @lines.empty?
      end

      def trim!
        i = @lines.size - 1
        while i >= 0 && @lines[i].blank? do
          @lines.delete_at(i)
          i -= 1
        end
      end

      def text
        text_with_indent.strip_indent
      end

      def lineno
        @lineno ||= @lines.map(&:lineno).minmax
      end

      def number_of_lines
        lineno[1] - lineno[0] + 1
      end

      def build_file_path(filename)
        @file_path = FilePath.new(filename, self)
      end

      def corrected_text_with_indent
        return unless @file_path

        indent = text_with_indent.indent
        @file_path.source.gsub(/^( *)(?=\S)/, "#{indent}\\1")
      end

      private

      def text_with_indent
        @lines.map(&:str).join
      end
    end
  end
end
