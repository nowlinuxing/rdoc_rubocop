module RDocRuboCop
  class Token
    class CommentToken < self
      COMMENT_CHAR = "#".freeze
      SPACE_CHAR = " ".freeze

      def self.indent_and_commentchar(indent_before_comment, indent_after_comment)
        SPACE_CHAR * indent_before_comment +
          COMMENT_CHAR +
          SPACE_CHAR * indent_after_comment
      end

      def comment?
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
