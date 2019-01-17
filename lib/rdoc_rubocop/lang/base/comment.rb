require "rdoc_rubocop/rdoc"

module RDocRuboCop
  module Lang
    module Base
      class Comment
        # def initialize(comment, source_file = nil)
        #   @comment = comment
        #   @source_file = source_file
        # end

        def source_codes
          @source_codes ||= extract_source_codes
        end

        # def corrected_text
        #   rdoc.apply
        # end

        private

        def extract_source_codes
          rdoc.ruby_snippets
        end

        def rdoc
          @rdoc ||= RDoc.new(text_without_commentchar)
        end

        # def text_without_commentchar
        #   @comment
        # end
      end
    end
  end
end
