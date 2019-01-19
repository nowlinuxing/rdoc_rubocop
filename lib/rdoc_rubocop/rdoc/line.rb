require "rdoc_rubocop/indent_util"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  class RDoc
    class Line
      attr_reader :lineno, :str

      def initialize(lineno, str)
        @lineno = lineno
        @str = str
      end

      def blank?
        /^ *$/.match?(@str)
      end

      def indent
        @str.expand_tab.indent
      end
    end
  end
end
