require "rdoc_rubocop/lang/c/comment"

module RDocRuboCop
  module Lang
    module C
      class CommentExtractor
        attr_reader :comments

        def initialize(source_file)
          @source_file = source_file
          @comments = []
        end

        def extract
          @comments = extract_comments
        end

        private

        def extract_comments
          pos = 0
          comments = []

          while match_data = %r(/\*.*?\*/)m.match(@source_file.source, pos) do
            comments << Comment.build(match_data[0], self, match_data.begin(0), match_data.end(0))
            pos = match_data.end(0)
          end

          comments
        end
      end
    end
  end
end
