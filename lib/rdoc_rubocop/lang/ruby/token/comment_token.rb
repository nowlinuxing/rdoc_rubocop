module RDocRuboCop
  module Lang
    module Ruby
      class Token
        class CommentToken < self
          def comment?
            true
          end
        end
      end
    end
  end
end
