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
      @comments =
        comment_tokens.
          slice_when { |token_before, token_after| token_after.lineno - token_before.lineno > 1 }.
          map { |comment_tokens| Comment.new(comment_tokens, @source_file) }
    end

    private

    def comment_tokens
      tokens.select(&:comment?)
    end

    def tokens
      Ripper.
        lex(@source_file.source).
        map { |token| Token.build(*token) }
    end
  end
end
