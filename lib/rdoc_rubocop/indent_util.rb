module RDocRuboCop
  module IndentUtil
    refine String do
      def indent
        scan(/^ *(?=\S)/).min
      end

      def strip_indent
        gsub(/^#{indent}/, "")
      end
    end
  end
end
