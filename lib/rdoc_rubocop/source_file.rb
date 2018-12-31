require "digest"
require "rdoc_rubocop/comment_extractor"
require "rdoc_rubocop/file_path"
require "rdoc_rubocop/source_file/corrector"

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

      reset
    end

    def source_code_file_paths
      @source_code_file_paths ||=
        comments.
          flat_map(&:source_codes).
          map { |source_code| FilePath.new(@filename, source_code) }
    end

    def comments
      comment_extractor = CommentExtractor.new(self)
      comment_extractor.extract
      comment_extractor.comments
    end

    def correct!
      correct
      save if changed?
      reset
    end

    def correct
      corrector = Corrector.new(@source, @source_code_file_paths)
      corrector.correct

      @source = corrector.source
    end

    private

    def reset
      @checksum = compute_digest(@source)
      @source_code_file_paths = nil
    end

    def compute_digest(str)
      Digest::MD5.hexdigest(str)
    end

    def save
      File.open(@filename, "w") do |f|
        f.puts @source
      end
    end

    def changed?
      compute_digest(@source) != @checksum
    end
  end
end
