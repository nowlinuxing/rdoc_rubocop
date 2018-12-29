require "rdoc_rubocop/token"

module RDocRuboCop
  class Comment
    class SourceCode
      include CommentTokenOrganizable

      attr_reader :comment

      def initialize(comment_tokens, comment = nil)
        @comment_tokens = comment_tokens
        @comment = comment
      end

      def text
        @comment_tokens.map { |comment_token| comment_token.text_without_indent(comment_indent) }.join
      end

      def lineno
        @lineno ||= comment_tokens.map(&:lineno).minmax
      end

      def indent_and_commentchar
        Token::CommentToken.indent_and_commentchar(comment_tokens[0].column, comment_indent)
      end
    end
  end
end
