require_relative 'presentation/presentation_comment'
require_relative 'presentation/presentation_helpers'
require_relative 'presentation/presentation_theme'
require_relative 'presentation/slide'
require_relative 'presentation/slide_size'
module OoxmlParser
  class Presentation < CommonDocumentStructure
    include PresentationHelpers
    attr_accessor :slides, :theme, :slide_size, :comments

    def initialize(slides = [], theme = nil, comments = [])
      @slides = slides
      @theme = theme
      @comments = comments
    end

    def self.parse
      OOXMLDocumentObject.root_subfolder = 'ppt/'
      OOXMLDocumentObject.xmls_stack = []
      OOXMLDocumentObject.add_to_xmls_stack('ppt/presentation.xml')
      doc = Nokogiri::XML(File.open(OOXMLDocumentObject.current_xml))
      presentation = Presentation.new
      presentation.theme = PresentationTheme.parse('ppt/theme/theme1.xml')
      presentation_node = doc.search('//p:presentation').first
      presentation_node.xpath('*').each do |presentation_node_child|
        case presentation_node_child.name
        when 'sldSz'
          presentation.slide_size = SlideSize.new(parent: presentation).parse(presentation_node_child)
        when 'sldIdLst'
          presentation_node_child.xpath('p:sldId').each do |silde_id_node|
            id = nil
            silde_id_node.attribute_nodes.select { |node| id = node.to_s if node.namespace && node.namespace.prefix == 'r' }
            presentation.slides << Slide.new(parent: presentation,
                                             xml_path: "#{OOXMLDocumentObject.root_subfolder}/#{OOXMLDocumentObject.get_link_from_rels(id)}")
                                   .parse
          end
        end
      end
      presentation.comments = PresentationComment.parse_list
      OOXMLDocumentObject.xmls_stack.pop
      presentation
    end

    class << self
      # @return [FontStyle] current font_style
      attr_accessor :current_font_style

      def current_font_style
        @current_font_style = FontStyle.new if @current_font_style.nil?
        @current_font_style
      end

      # @return [String] default_font_typeface
      def default_font_typeface
        'Arial'
      end

      # @return [FixNum] default_font_typeface
      def default_font_size
        18
      end
    end
  end
end
