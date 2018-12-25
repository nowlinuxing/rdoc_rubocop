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

    %i(on_sp on_comment).each do |type|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{type.to_s.sub(/^on_/, "")}? # def sp?
          type == :#{type}                #   type == :on_sp
        end                               # end
      RUBY
    end
  end
end

require "rdoc_rubocop/token/comment_token"
