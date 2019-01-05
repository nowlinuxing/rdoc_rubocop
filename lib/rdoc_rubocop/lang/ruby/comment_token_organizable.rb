module RDocRuboCop
  module Lang
    module Ruby
      module CommentTokenOrganizable
        def self.included(base)
          base.include InstanceMethods

          attr_reader :comment_tokens
        end

        module InstanceMethods
          private

          def comment_indent
            @comment_indent ||= @comment_tokens.reject(&:blank?).map(&:comment_indent).min
          end
        end
      end
    end
  end
end
