require 'spec_helper'
module Sexpr::Parser
  describe Citrus, "parse" do

    let(:parser){ Citrus.new(bool_expr_parser) }

    it 'delegates the call to the Citrus parser' do
      parser.parse("true").should be_a(::Citrus::Match)
    end

    it 'is idempotent' do
      parser.parse(parser.parse("true")).should be_a(::Citrus::Match)
    end

    it 'raises a Citrus::ParserError when parsing fails' do
      lambda{
        parser.parse("bl and or")
      }.should raise_error(::Citrus::ParseError)
    end

    it 'recognizes the :root option' do
      parser.parse("true", :root => :bool_lit).should be_a(::Citrus::Match)
      parser.parse("x", :root => :var_ref).should be_a(::Citrus::Match)
      lambda{
        parser.parse("x", :root => :bool_lit)
      }.should raise_error(::Citrus::ParseError)
    end

    it 'recognizes the :consume option' do
      lambda{
        parser.parse("true or")
      }.should raise_error(::Citrus::ParseError)
      parser.parse("true or", :consume => false).should eq("true")
    end

    it 'can parse from a Path' do
      Path.tmpfile do |tmp|
        tmp.write "x and y"
        parser.parse(tmp).should be_a(::Citrus::Match)
      end
    end

  end
end