require "spec_helper"

RSpec.describe RDocRuboCop::Lang::C::CommentExtractor do
  describe "#extract" do
    let(:source_file) { RDocRuboCop::Lang::C::SourceFile.new(source, "foo.c") }

    let(:source) do
      <<-RUBY.strip_heredoc
        /*
         * comment for Foo
         */

        void
        Init_Foo(void)
        {
          cFoo = rb_define_class("Foo", rb_cObject);

          /*
           * comment for rb_define_attr
           */
          rb_define_attr(cFoo, "bar", 1, 1);
        }
      RUBY
    end

    subject { described_class.new(source_file).extract }

    it "should return a comment" do
      expect(subject.size).to eq(2)

      expect(subject[0].comment_text).to eq(<<-RUBY.strip_heredoc.chomp)
        /*
         * comment for Foo
         */
      RUBY

      expect(subject[1].comment_text).to eq(<<-RUBY.strip_heredoc.chomp)
        /*
           * comment for rb_define_attr
           */
      RUBY
    end
  end
end
