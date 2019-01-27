module RDocRuboCop
  module IndentUtil
    refine String do
      def indent
        scan(/^ *(?=\S)/).min
      end

      def strip_indent
        gsub(/^#{indent}/, "")
      end

      # Since space indent and tab indent are mixed in Ruby source code,
      # it is unified with space indent.
      def expand_tab
        gsub(/\t/, "    ")
      end
    end
  end
end
