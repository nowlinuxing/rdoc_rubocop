module RDocRuboCop
  module Lang
    module C
      class Comment
        attr_reader :comment_text
        attr_reader :source_file
        attr_reader :offset_begin
        attr_reader :offset_end

        def initialize(comment_text, source_file, offset_begin, offset_end)
          @comment_text = comment_text
          @source_file = source_file
          @offset_begin = offset_begin
          @offset_end = offset_end
        end
      end
    end
  end
end
