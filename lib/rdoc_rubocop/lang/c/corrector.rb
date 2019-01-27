module RDocRuboCop
  module Lang
    module C
      class Corrector
        attr_reader :corrected_source

        def initialize(source_file)
          @source_file = source_file
          @corrected_source = nil
        end

        def correct
          @corrected_source = @source_file.source.dup

          @source_file.comments.reverse_each do |comment|
            next if comment.source_codes.empty?

            index = comment.offset_begin
            length = comment.length
            @corrected_source[index, length] = comment.corrected_text
          end
        end
      end
    end
  end
end
