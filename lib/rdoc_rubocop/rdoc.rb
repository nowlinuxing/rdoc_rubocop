require "rdoc_rubocop/rdoc/line"
require "rdoc_rubocop/rdoc/ruby_snippet"

module RDocRuboCop
  class RDoc
    attr_reader :text
    attr_reader :ruby_snippets

    def initialize(text)
      @text = text

      @ruby_snippets = []
      @parsed = false
    end

    def ruby_snippets
      parse unless @parsed
      @ruby_snippets
    end

    def apply
      lines = text_lines

      @ruby_snippets.reverse_each do |ruby_snippet|
        next unless ruby_snippet.corrected_text_with_indent

        index = ruby_snippet.lineno[0] - 1
        number_of_lines = ruby_snippet.number_of_lines
        lines[index, number_of_lines] = ruby_snippet.corrected_text_with_indent
      end

      lines.join
    end

    private

    def parse
      @ruby_snippets = []
      ruby_snippet = RubySnippet.new
      is_in_call_seq = false

      lines = text_lines.map.with_index { |line, i| Line.new(1 + i, line) }
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

    def text_lines
      @text_lines ||= @text.lines
    end
  end
end
