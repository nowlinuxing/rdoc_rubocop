require "rdoc_rubocop/comment/source_code"

module RDocRuboCop
  class Comment
    attr_reader :comment_tokens
    attr_reader :source_file

    def initialize(comment_tokens, source_file = nil)
      @comment_tokens = comment_tokens
      @source_file = source_file
    end

    def source_codes
      code_chunk = []
      codes = []
      @comment_tokens.each do |comment_token|
        if comment_token.comment_indent > comment_indent
          code_chunk << comment_token
        elsif comment_token.blank? && code_chunk.any?
          code_chunk << comment_token
        elsif code_chunk.any?
          codes << SourceCode.new(trim(code_chunk))
          code_chunk = []
        end
      end
      codes << SourceCode.new(trim(code_chunk), self) if code_chunk.any?

      codes
    end

    private

    def comment_indent
      @comment_indent ||= @comment_tokens.reject(&:blank?).map(&:comment_indent).min
    end

    def trim(code_chunk)
      i = code_chunk.size - 1
      while i >= 0 && code_chunk[i].blank? do
        code_chunk.delete_at(i)
        i -= 1
      end

      code_chunk
    end
  end
end
