require "rdoc_rubocop/token/comment_token"

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
    end
  end
end
