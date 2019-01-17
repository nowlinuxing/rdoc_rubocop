require "rdoc_rubocop/indent_util"

using RDocRuboCop::IndentUtil

module RDocRuboCop
  module Lang
    module C
      class Comment < Lang::Base::Comment
        #
        # This class manages comments of the following form:
        #
        #   /*
        #    * Document-class: Foo
        #    *
        #    *   code1
        #    *   code2
        #    */
        #
        class Normal < self
          def corrected_text
            body = rdoc.apply

            first_line = body.slice!(/\A.*\R/)
            body.gsub!(/^/, indent)

            text = "/*#{@indent_after_asterisk}#{first_line}#{body}".gsub(/ *$/, "")
            "#{text}#{@end_str}"
          end

          private

          def parse
            body = @comment_text.dup

            #
            # /*          <- first_line
            #  * comment1
            #  *
            #  * comment2
            #  */         <- @end_str
            #
            first_line = body.slice!(/\A.*\R/)
            @end_str = body.slice!(%r(^.*\*/\z))

            tmp_indent = @end_str[/^ */]
            body = tmp_indent + "*" + first_line.sub(%r(/\*), "") + body

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
