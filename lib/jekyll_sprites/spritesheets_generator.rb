require 'fileutils'
require 'zlib'
require_relative 'util'
require_relative 'config'
require_relative 'hook_actions'

class SpritesheetsGenerator

    def initialize()
        @svg_properties = {}
        @rexml_spritesheet_properties = {}
    end

    def add_svg_properties(svg_rel_path, page_path)
        @svg_properties[svg_rel_path] ||= {}
        @svg_properties[svg_rel_path]["pages"] ||= {}
        @svg_properties[svg_rel_path]["pages"][page_path] ||= (svg_rel_path+page_path).gsub(/[^0-9a-zA-Z]/, '')
        @svg_properties[svg_rel_path]["spritesheet"] = Zlib.crc32(@svg_properties[svg_rel_path]["pages"].keys.join).to_s(16)+".svg"
    end

    def get_svg_properties()
        @svg_properties
    end

    def get_url_replacement_id(svg_rel_path, page_path) #think of better name
        @svg_properties[svg_rel_path]["pages"][page_path]
    end

    def generate()
        self._build_rexml_spritesheets()
        self._build_rexml_sprites()
        self._clone_rexml_sprites_into_rexml_spritesheets()
    end

    def write(spritesheets_dest) #need to change to write to sites folder (programatically, get site dest... not just adding  _site to rel path)
        FileUtils.mkdir_p(spritesheets_dest)
        @rexml_spritesheet_properties.each_pair do |spritesheet_name, properties|
            spritesheet_path = File.join(spritesheets_dest, spritesheet_name)
            Util::REXMLHelpers.write_rexml_to_file(spritesheet_path, properties["spritesheet"])
        end
    end

    private

    def _build_rexml_spritesheets()
        @svg_properties.each_value do |properties|
            spritesheet = Util::REXMLHelpers.create_rexml_element("svg", {
                "width": "0",
                "height": "0",
                "class": "hidden",
                "xmlns": "http://www.w3.org/2000/svg",
                "xmlns:xlink": "http://www.w3.org/1999/xlink"
            })
            @rexml_spritesheet_properties[properties["spritesheet"]] = {}
            @rexml_spritesheet_properties[properties["spritesheet"]]["spritesheet"] = spritesheet

        end
    end

    def _build_rexml_sprites()
        @svg_properties.each_pair do |svg_rel_path, properties|
            @rexml_spritesheet_properties[properties["spritesheet"]]["sprites"] ||= Set.new
            rexml_svg = Util::REXMLHelpers.svg_to_rexml_svg(File.join(Config.get(site.config, "svg_dir"), svg_rel_path))
            rexml_sprite = Util::REXMLHelpers.rexml_svg_to_rexml_sprite(rexml_svg)
            @rexml_spritesheet_properties[properties["spritesheet"]]["sprites"].add(rexml_sprite)
        end
    end

    def _clone_rexml_sprites_into_rexml_spritesheets()
        @rexml_spritesheet_properties.each_value do |properties|
            properties["sprites"].each do |rexml_sprite|
                properties["spritesheet"].add_element(rexml_sprite.deep_clone)
            end
        end
    end

end