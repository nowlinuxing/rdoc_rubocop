require "rdoc_rubocop/lang/ruby/token/comment_token"

module RDocRuboCop
  module Lang
    module Ruby
      class Corrector
        attr_reader :source

        def initialize(source, source_code_file_paths)
          @source = source
          @source_code_file_paths = source_code_file_paths
        end

        def correct
          source_lines = source.lines

          @source_code_file_paths.reverse_each do |file_path|
            apply(source_lines, file_path)
          end

          @source = source_lines.join
        end

        private

        def apply(source_lines, file_path)
          indent_and_commentchar = file_path.source_code.indent_and_commentchar
          source_with_indent =
            file_path.source.
            gsub(/^/, indent_and_commentchar).
            gsub(/#{Token::CommentToken::COMMENT_CHAR}\s*$/, "#")

          index = file_path.source_code.lineno[0] - 1
          number_of_lines = file_path.source_code.number_of_lines
          source_lines[index, number_of_lines] = source_with_indent
        end
      end
    end
  end
end
