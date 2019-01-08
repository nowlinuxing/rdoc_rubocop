require "rdoc_rubocop/indent_util"
require "rdoc_rubocop/rdoc/line"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  class RDoc
    class RubySnippet
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
        @lines.map(&:str).join.strip_indent
      end

      def lineno
        @lines.map(&:lineno).minmax
      end
    end
  end
end
