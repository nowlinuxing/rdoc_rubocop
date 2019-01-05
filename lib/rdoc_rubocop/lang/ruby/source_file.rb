require "rdoc_rubocop/lang/ruby/comment_extractor"
require "rdoc_rubocop/lang/ruby/corrector"

module RDocRuboCop
  module Lang
    module Ruby
      class SourceFile < ::RDocRuboCop::SourceFile
        def comment_extractor_class
          CommentExtractor
        end

        def corrector_class
          Corrector
        end
      end
    end
  end
end
