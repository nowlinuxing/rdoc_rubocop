require "rdoc_rubocop/rdoc/line"
require "rdoc_rubocop/rdoc/ruby_snippet"

module RDocRuboCop
  class RDoc
    def initialize(text)
      @text = text

      @ruby_snippets = []
      @parsed = false
    end

    def ruby_snippets
      parse unless @parsed
      @ruby_snippets
    end

    private

    def parse
      @ruby_snippets = []
      ruby_snippet = RubySnippet.new
      is_in_call_seq = false

      lines.each do |line|
        if line.blank?
          ruby_snippet.append(line) if !ruby_snippet.empty?
        elsif line.indent.length > 0
          ruby_snippet.append(line) if !is_in_call_seq
        elsif line.str.match?(/^call-seq:/)
          is_in_call_seq = true
          ruby_snippet = RubySnippet.new
        else
          is_in_call_seq = false

          if !ruby_snippet.empty?
            @ruby_snippets << ruby_snippet.tap(&:trim!)
            ruby_snippet = RubySnippet.new
          end
        end
      end
      @ruby_snippets << ruby_snippet.tap(&:trim!) if !ruby_snippet.empty?

      @parsed = true
    end

    def lines
      @text.lines.map.with_index { |line, i| Line.new(1 + i, line) }
    end
  end
end
