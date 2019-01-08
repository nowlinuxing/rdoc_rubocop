require "spec_helper"
require "rdoc_rubocop/rdoc"

RSpec.describe RDocRuboCop::RDoc do
  describe "#ruby_snippets" do
    let(:rdoc) { described_class.new(rdoc_text) }

    subject { rdoc.ruby_snippets }

    context "when the rdoc has two rdocs" do
      let(:rdoc_text) do
        <<-RUBY.strip_heredoc
          comment

            Foo.bar(1 , 2)
            Foo.bar(1 , 2 , 3)

          comment2

            Foo.new(1).bar(2)

        RUBY
      end

      it "should return two instances of RubySnippet" do
        expect(subject.size).to eq(2)

        expect(subject[0]).to be_an_instance_of(RDocRuboCop::RDoc::RubySnippet)
        expect(subject[0].text).to eq(<<-COMMENT.strip_heredoc)
          Foo.bar(1 , 2)
          Foo.bar(1 , 2 , 3)
        COMMENT
        expect(subject[0].lineno).to eq([3, 4])

        expect(subject[1]).to be_an_instance_of(RDocRuboCop::RDoc::RubySnippet)
        expect(subject[1].text).to eq(<<-COMMENT.strip_heredoc)
          Foo.new(1).bar(2)
        COMMENT
        expect(subject[1].lineno).to eq([8, 8])
      end
    end

    context "when the rdoc has *call-seq* directive" do
      let(:rdoc_text) do
        <<-RUBY.strip_heredoc
          call-seq:
            Foo.bar(obj, ...) -> obj

          comment

            Foo.bar(1 , 2)
            Foo.bar(1 , 2 , 3)

        RUBY
      end

      it "should return an instance of RubySnippet" do
        expect(subject.size).to eq(1)

        expect(subject[0]).to be_an_instance_of(RDocRuboCop::RDoc::RubySnippet)
        expect(subject[0].text).to eq(<<-COMMENT.strip_heredoc)
          Foo.bar(1 , 2)
          Foo.bar(1 , 2 , 3)
        COMMENT
        expect(subject[0].lineno).to eq([6, 7])
      end
    end
  end

  describe "#apply" do
    let(:rdoc) do
      described_class.new(<<-RUBY.strip_heredoc)
        comment

          Foo.bar(1 , 2) do |a , b|
            [a , b]
          end

        comment2

          Foo.bar(1 , 2 , 3 , 4)

      RUBY
    end

    before do
      filename = "path/to/dir/sample.rb"

      rdoc.ruby_snippets[0].build_file_path(filename).source = <<-RUBY.strip_heredoc
        Foo.bar(1, 2) do |a, b|
          [a, b]
        end
      RUBY

      rdoc.ruby_snippets[1].build_file_path(filename).source = <<-RUBY.strip_heredoc
        Foo.bar(1, 2, 3, 4)
      RUBY
    end

    subject { rdoc.apply }

    it "should return corrected text" do
      expect(subject).to eq(<<-RUBY.strip_heredoc)
        comment

          Foo.bar(1, 2) do |a, b|
            [a, b]
          end

        comment2

          Foo.bar(1, 2, 3, 4)

      RUBY
    end
  end
end
