require "rdoc_rubocop/lang/ruby/token/comment_token"

module RDocRuboCop
  module Lang
    module Ruby
      class Corrector
        attr_reader :corrected_source

        def initialize(source_file)
          @source_file = source_file
          @corrected_source = nil
        end

        def correct
          source_lines = @source_file.source.lines

          @source_file.comments.reverse_each do |comment|
            next if comment.source_codes.empty?

            index = comment.lineno[0] - 1
            number_of_lines = comment.number_of_lines
            source_lines[index, number_of_lines] = comment.corrected_text
          end

          @corrected_source = source_lines.join
        end
      end
    end
  end
end
