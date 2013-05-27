require 'test/unit'
require 'css_parser'

require "#{File.dirname(__FILE__)}/../src/splicer.rb"



class SpliceTest < Test::Unit::TestCase
  include CssParser
  include CssSplicer
  
  def setup
    @parser = CssParser::Parser.new
    @splicer = CssSplicer::Splicer.new('test')
    @css = "body { width: 100%; background-color: \#000; }"
    @parser.add_block!(@css)
  end

  def test_only_width
    @splicer.add_allowed_properties!(['width'])
    @splicer.add_valid_rules!(@parser)
    assert_equal 'body { width: 100%; }', @splicer.to_s
  end

  def test_both
    @splicer.add_allowed_properties!(['width', 'background-color'])
    @splicer.add_valid_rules!(@parser)
    assert_equal @css, @splicer.to_s
  end

  def test_complex_selector
    complex = "body > div.test + blockquote[name=test] { color: red; }"
    @parser.add_block!(complex)

    @splicer.add_allowed_properties!(['color'])
    @splicer.add_valid_rules!(@parser)

    assert_equal complex, @splicer.to_s
  end

  def test_split_selector
    pre_split = "body, p { color: red; }"
    split = <<-CSS
      body { color: red; }
      p {color: red; }
    CSS
    @parser.add_block!(split)

    @splicer.add_allowed_properties!(['color'])
    @splicer.add_valid_rules!(@parser)

    # trim whitespace when testing
    assert_equal split.gsub(/\s/, ''), @splicer.to_s.gsub(/\s/, '')
  end

end
