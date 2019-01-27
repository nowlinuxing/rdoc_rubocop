module RDocRuboCop
  module Lang
    module C
      class Comment < Lang::Base::Comment
        class OneLine < self
          def corrected_text
            "#{@begin_str}#{rdoc.apply}#{@end_str}"
          end

          private

          def parse
            @body = @comment_text.dup

            @begin_str = @body.slice!(%r(^/\*\s*))
            @end_str = @body.slice!(%r(\s*\*/$))
          end
        end
      end
    end
  end
end
