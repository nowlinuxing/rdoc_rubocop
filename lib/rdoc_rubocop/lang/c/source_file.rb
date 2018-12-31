require "rdoc_rubocop/lang/c/comment_extractor"

module RDocRuboCop
  module Lang
    module C
      class SourceFile < Lang::Base::SourceFile
        def comment_extractor_class
          C::CommentExtractor
        end
      end
    end
  end
end
