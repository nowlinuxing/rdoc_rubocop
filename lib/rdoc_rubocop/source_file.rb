require "rdoc_rubocop/comment_extractor"
require "rdoc_rubocop/file_path"

module RDocRuboCop
  class SourceFile
    attr_reader :source
    attr_reader :filename

    def self.build(filename)
      source = File.open(filename, "r").read
      new(source, filename)
    end

    def initialize(source, filename)
      @source = source
      @filename = filename
    end

    def source_code_file_paths
      comments.flat_map do |comment|
        comment.source_codes.map do |source_code|
          FilePath.new(@filename, source_code.text)
        end
      end
    end

    def comments
      comment_extractor = CommentExtractor.new(self)
      comment_extractor.extract
      comment_extractor.comments
    end
  end
end
