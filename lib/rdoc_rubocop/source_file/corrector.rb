require "rdoc_rubocop/token/comment_token"

module RDocRuboCop
  class SourceFile
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

        @source = source_lines.flatten.join
      end

      private

      def apply(source_lines, file_path)
        lineno = file_path.source_code.lineno

        delete_lines(source_lines, lineno[0] - 1, lineno[1] - 1)
        insert(source_lines, lineno[0] - 1, file_path)
      end

      def delete_lines(source_lines, lineno_from, lineno_to)
        (lineno_to).downto(lineno_from).each do |i|
          source_lines.delete_at(i)
        end
      end

      def insert(source_lines, index, file_path)
        indent_and_commentchar = file_path.source_code.indent_and_commentchar
        source_with_indent =
          file_path.source.
          gsub(/^/, indent_and_commentchar).
          gsub(/#{Token::CommentToken::COMMENT_CHAR}\s*$/, "#")

        source_lines.insert(index, source_with_indent)
      end
    end
  end
end
