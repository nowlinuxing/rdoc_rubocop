require "rdoc_rubocop/lang/base/comment"
require "rdoc_rubocop/indent_util"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  module Lang
    module Ruby
      class Comment < Lang::Base::Comment
        attr_reader :comment_tokens
        attr_reader :source_file

        def initialize(comment_tokens, source_file = nil)
          @comment_tokens = comment_tokens
          @source_file = source_file
        end

        def corrected_text
          rdoc.
            apply.
            gsub(/^/, indent_and_commentchar).
            gsub(/ *$/, "")
        end

        def lineno
          @lineno ||= @comment_tokens.map(&:lineno).minmax
        end

        def number_of_lines
          lineno[1] - lineno[0] + 1
        end

        private

        def text_without_commentchar
          text.gsub(/^ *#/, "").strip_indent
        end

        def indent_and_commentchar
          indent = " " * @comment_tokens.map(&:column).min
          commentchar_and_indent = text.scan(/^# *(?=\S)/).min

          "#{indent}#{commentchar_and_indent}"
        end

        def text
          @text ||= @comment_tokens.map(&:token).join
        end
      end
    end
  end
end
