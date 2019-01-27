require "rdoc_rubocop/lang/c/comment_extractor"
require "rdoc_rubocop/lang/c/corrector"

module RDocRuboCop
  module Lang
    module C
      class SourceFile < Lang::Base::SourceFile
        def comment_extractor_class
          C::CommentExtractor
        end

        def corrector_class
          C::Corrector
        end
      end
    end
  end
end
