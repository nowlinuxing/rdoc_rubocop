module RDocRuboCop
  class Token
    class CommentToken < self
      COMMENT_CHAR = "#".freeze
      SPACE_CHAR = " ".freeze

      def on_comment?
        true
      end

      def comment_indent
        text_with_indent[/^#{SPACE_CHAR}*/].length
      end

      def text_with_indent
        token.sub(COMMENT_CHAR, "")
      end

      def text_without_indent(indent)
        text_with_indent.sub(/^#{SPACE_CHAR}{#{indent}}/, "")
      end

      def blank?
        text_with_indent.match?(/^\s*$/)
      end
    end
  end
end
