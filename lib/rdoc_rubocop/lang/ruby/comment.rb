require "rdoc_rubocop/rdoc"
require "rdoc_rubocop/indent_util"

require "rdoc_rubocop/lang/ruby/comment_token_organizable"
require "rdoc_rubocop/lang/ruby/source_code"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  module Lang
    module Ruby
      class Comment
        attr_reader :comment_tokens
        attr_reader :source_file

        def initialize(comment_tokens, source_file = nil)
          @comment_tokens = comment_tokens
          @source_file = source_file
        end

        def source_codes
          @source_codes ||= extract_source_codes
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

        def extract_source_codes
          rdoc.ruby_snippets
        end

        def rdoc
          @rdoc ||=
            begin
              text_without_commentchar = text.gsub(/^ *#/, "").strip_indent
              RDoc.new(text_without_commentchar)
            end
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
