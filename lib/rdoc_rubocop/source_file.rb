require "digest"
require "rdoc_rubocop/file_path"

module RDocRuboCop
  class SourceFile
    attr_reader :source
    attr_reader :filename

    def self.build(filename)
      klass =
        case filename
        when /\.rb\z/ then Lang::Ruby::SourceFile
        end

      return unless klass

      source = File.open(filename, "r").read
      klass.new(source, filename)
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
      comment_extractor = comment_extractor_class.new(self)
      comment_extractor.extract
      comment_extractor.comments
    end

    # def comment_extractor_class
    #   CommentExtractor
    # end

    def correct!
      correct
      save if changed?
      reset
    end

    def correct
      corrector = corrector_class.new(@source, @source_code_file_paths)
      corrector.correct

      @source = corrector.source
    end

    # def corrector_class
    #   Corrector
    # end

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

require "rdoc_rubocop/lang/ruby/source_file"
