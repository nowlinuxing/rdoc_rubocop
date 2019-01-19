require "rdoc_rubocop/indent_util"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  module Lang
    module C
      class Comment < Lang::Base::Comment
        #
        # This class manages comments of the following form:
        #
        #   /**********************
        #    * Document-class: Foo
        #    *
        #    *   code1
        #    *   code2
        #    **********************/
        #
        # Those whose body is before the column position of the comment
        # start are also included.
        #
        #   /*
        #    Document-class: Foo
        #
        #      code1
        #      code2
        #    */
        #
        class Banner < self
          def corrected_text
            body = rdoc.apply

            text = body.gsub(/^/, indent).gsub(/ *$/, "")
            text = "#{@padding_begin_str}#{text}"

            "#{text}#{@end_str}"
          end

          private

          def parse
            body = @comment_text.expand_tab

            #
            # /*********  <- @padding_begin_str
            #  * comment1 <- first_line
            #  *
            #  * comment2
            #  #********/ <- @end_str
            #
            @padding_begin_str = body.slice!(/\A.*\R/)
            @end_str = body.slice!(%r(^.*\*/\z))

            @indent_before_asterisk = body.scan(/^ *\*/).min || ""
            @indent_after_asterisk = body.gsub(/^ *\*/, "").indent || ""
            indent = @indent_before_asterisk + @indent_after_asterisk

            @body = body.gsub(/^.{0,#{indent.length}}/, "")
          end

          def indent
            @indent_before_asterisk + @indent_after_asterisk
          end
        end
      end
    end
  end
end
