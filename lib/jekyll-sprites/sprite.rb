require "rexml" #import each from respective then do away with long :: :: ::
require 'stringio'
require 'zlib'

module Jekyll

  module Sprites
  
    class Sprite #inherit from a base class of helpers?

      attr_reader :attributes :pages :id #if i am generating the spritesheet name in here do i need pages? do i need outside access to id?
      attr_accessor :page_path
        
      def initialize(attributes, config)
        @config=config
        @attributes = attributes
        _validate_attributes
        @svg_path = _get_svg_path
        _validate_svg_path
        @id = _get_id
        @pages = Set.new
      end

      def register_page(page_path)
        @page_path = page_path #make it page and just do @page.path
        @pages.add(page_path)
      end

      def get_html
        attributes_string = @attributes.map { |key, value| "#{key}=\"#{value}\"" }.join(" ")
        url_placeholder = get_url_placeholder(@page_path)
        url = _get_url(url_placeholder, @page_path)
        indentation = Configuration.get(@config, ["sprites", "indentation"])
        "<svg #{attributes_string} >#{" "*indentation}<use href=\"#{url}\"></use></svg>"
      end

      def get_rexml
        svg_data = File.read(@svg_path)
        rexml_svg_doc = REXML::Document.new(svg_data)
        rexml_svg = rexml_svg_doc.elements["svg"]
        rexml_sprite = REXML::Element.new("symbol", { "id", @id })
        rexml_sprite.add_element(rexml_svg.deep_clone)
        rexml_sprite
      end

      def get_url_placeholder(page_path)
        "{#{(@svg_path + (page_path || @page_path)).gsub(/[^0-9a-zA-Z]/, "")}}"
      end

      def get_spritesheet_name
        "#{Zlib.crc32(@pages.join).to_s(16)}"
      end

      private

      def _get_svg_path
        File.join(Configuration.get(@config, %w[sprites svg_dir]), @attributes["src"])
      end

      def _get_id
        "#{Zlib.crc32(@svg_path).to_s(16)}"
      end

      def _get_url(placeholder)
        path_modifier = "../" * @page_path.count("/")
        base_url = Configuration.get(@config, "baseurl")
        base_url = path_modifier == "" ? "#{base_url.sub(%r{/+$}, "")}/" : path_modifier
        "#{base_url}#{placeholder}##{@id}"
      end

      def _validate_attributes
        return if @attributes.keys.include?("src")

        raise Jekyll::Errors::FatalException,
              "No SVG src provided in `#{@attributes}`"
      end

      def _validate_svg_path
        return if File.exist?(@svg_path)

        raise Jekyll::Errors::FatalException,
              "SVG src does not exist in `#{@svg_path}`"
      end

  end

end