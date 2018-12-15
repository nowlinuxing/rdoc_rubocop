module RDocRuboCop
  class Token
    attr_reader :locate, :type, :token, :state

    def self.build(locate, type, token, state)
      case type
      when :on_comment
        CommentToken.new(locate, type, token, state)
      else
        new(locate, type, token, state)
      end
    end

    def initialize(locate, type, token, state)
      @locate = locate
      @type   = type
      @token  = token
      @state  = state
    end

    def lineno
      @locate[0]
    end

    def column
      @locate[1]
    end

    def on_comment?
      false
    end
  end
end

require "rdoc_rubocop/token/comment_token"
