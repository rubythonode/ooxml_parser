module OoxmlParser
  # Class for parsing `u` tags
  class Underline < OOXMLDocumentObject
    attr_accessor :style, :color

    def initialize(style = :none, color = nil, parent: nil)
      @style = style == 'single' ? :single : style
      @color = color
      @parent = parent
    end

    def ==(other)
      if other.is_a? Underline
        @style.to_sym == other.style.to_sym && @color == other.color
      elsif other.is_a? Symbol
        @style.to_sym == other
      else
        false
      end
    end

    def to_s
      if @color.nil?
        @style.to_s
      else
        "#{@style} #{@color}"
      end
    end

    # Parse Underline object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [Underline] result of parsing
    def parse(node)
      case node
      when 'sng'
        @style = :single
      when 'none'
        @style = :none
      end
      self
    end
  end
end
