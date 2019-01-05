module RDocRuboCop
  class FilePath < String
    attr_reader :source_code
    attr_accessor :source

    def initialize(str, source_code)
      super(str)
      @source_code = source_code
      @source = @source_code.text
    end
  end
end
