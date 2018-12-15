require "rdoc_rubocop/comment_extractor"

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

    def comments
      comment_extractor = CommentExtractor.new(self)
      comment_extractor.extract
      comment_extractor.comments
    end
  end
end
