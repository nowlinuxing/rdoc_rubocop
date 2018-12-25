require 'ripper'
require 'rdoc_rubocop/token'
require 'rdoc_rubocop/comment'

module RDocRuboCop
  class CommentExtractor
    attr_reader :comments

    def initialize(source_file)
      @source_file = source_file
      @comments = []
    end

    def extract
      @comments = extract_comments
    end

    private

    def extract_comments
      chunk = []
      comments = []

      tokens.each do |tokens_in_line|
        token = tokens_in_line.pop

        if token.comment?
          if tokens_in_line.all?(&:sp?)
            chunk << token
          else
            comments << Comment.new(chunk, @source_file) if chunk.any?
            chunk = [token]
          end
        else
          if chunk.any?
            comments << Comment.new(chunk, @source_file)
            chunk = []
          end
        end
      end
      comments << Comment.new(chunk, @source_file) if chunk.any?

      comments
    end

    def tokens
      Ripper.
        lex(@source_file.source).
        map { |token| Token.build(*token) }.
        slice_when { |token_before, token_after| token_before.lineno != token_after.lineno }
    end
  end
end
