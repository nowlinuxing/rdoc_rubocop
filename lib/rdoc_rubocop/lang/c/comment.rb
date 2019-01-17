require "rdoc_rubocop/lang/base/comment"

module RDocRuboCop
  module Lang
    module C
      class Comment < Lang::Base::Comment
        attr_reader :comment_text
        attr_reader :source_file
        attr_reader :offset_begin
        attr_reader :offset_end

        def self.build(comment_text, source_file, offset_begin, offset_end)
          body = comment_text.dup
          first_line = body.slice!(/\A.*\R/)

          klass =
            if first_line.nil?
              Comment::OneLine
            elsif first_line.match?(%r(^/\*[\x21-\x2f\x3a-\x3f])) || !body.match?(/\A *\*/)
              Comment::Banner
            else
              Comment::Normal
            end

          klass.new(comment_text, source_file, offset_begin, offset_end)
        end

        def initialize(comment_text, source_file, offset_begin, offset_end)
          @comment_text = comment_text
          @source_file = source_file
          @offset_begin = offset_begin
          @offset_end = offset_end
        end

        # def corrected_text
        # end

        def length
          @offset_end - @offset_begin
        end

        private

        def text_without_commentchar
          parse unless @body
          @body
        end

        # def parse
        # end
      end
    end
  end
end

require "rdoc_rubocop/lang/c/comment/one_line"
require "rdoc_rubocop/lang/c/comment/normal"
require "rdoc_rubocop/lang/c/comment/banner"
