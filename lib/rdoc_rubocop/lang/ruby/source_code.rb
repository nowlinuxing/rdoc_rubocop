require "rdoc_rubocop/lang/ruby/comment_token_organizable"
require "rdoc_rubocop/file_path"
require "rdoc_rubocop/lang/ruby/token"

module RDocRuboCop
  module Lang
    module Ruby
      class SourceCode
        include CommentTokenOrganizable

        attr_reader :comment
        attr_reader :file_path

        def initialize(comment_tokens, comment = nil)
          @comment_tokens = comment_tokens
          @comment = comment
        end

        def build_file_path(filename)
          @file_path = FilePath.new(filename, self)
        end

        def text
          @comment_tokens.map { |comment_token| comment_token.text_without_indent(comment_indent) }.join
        end

        def lineno
          @lineno ||= comment_tokens.map(&:lineno).minmax
        end

        def number_of_lines
          @lineno[1] - @lineno[0] + 1
        end

        def indent_and_commentchar
          Token::CommentToken.indent_and_commentchar(comment_tokens[0].column, comment_indent)
        end
      end
    end
  end
end
