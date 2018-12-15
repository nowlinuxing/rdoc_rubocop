require "rdoc_rubocop/token/comment_token"

module RDocRuboCop
  class Comment
    class SourceCode
      attr_reader :comment_tokens
      attr_reader :comment

      def initialize(comment_tokens, comment = nil)
        @comment_tokens = comment_tokens
        @comment = comment
      end
    end
  end
end
