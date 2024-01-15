require 'fileutils'
require 'zlib'
require_relative 'util'
require_relative 'config'

module Jekyll

    module Sprites
    
        class SpritesheetGenerator

            def initialize()
                @svg_properties = {}
                @rexml_spritesheet_properties = {}
            end

            def set_svg_properties(svg_path, page_path)
                SpritesheetGenerator._validate_svg_path(svg_path)
                @svg_properties[svg_path] ||= {}
                @svg_properties[svg_path]["pages"] ||= {}
                @svg_properties[svg_path]["pages"][page_path] ||= (svg_path+page_path).gsub(/[^0-9a-zA-Z]/, '')
                @svg_properties[svg_path]["spritesheet"] = Zlib.crc32(@svg_properties[svg_path]["pages"].keys.join).to_s(16)+".svg"
            end

            def get_url_placeholder(svg_path, page_path)
                @svg_properties[svg_path]["pages"][page_path]
            end

            def update_url_placeholders(site)
                site.pages.each do |page|
                    @svg_properties.each_value do |properties|
                        if properties["pages"].keys.include?(page.path)
                            updated_content = page.output.gsub(properties["pages"][page.path], File.join(Configuration.get(site.config, ["sprites", "spritesheet_dir"]), properties["spritesheet"]))
                            page.output = updated_content
                        end
                    end
                end

            end

            def generate()
                self._build_rexml_spritesheets()
                self._build_rexml_sprites()
                self._clone_rexml_sprites_into_rexml_spritesheets()
            end

            def write(site)
                spritesheet_dest = File.join(site.dest, Configuration.get(site.config, ["sprites", "spritesheet_dir"]))
                FileUtils.mkdir_p(spritesheet_dest)
                @rexml_spritesheet_properties.each_pair do |spritesheet_name, properties|
                    spritesheet_path = File.join(spritesheet_dest, spritesheet_name)
                    Util::REXMLHelpers.write_rexml_to_file(spritesheet_path, properties["spritesheet"])
                end
            end

            private

            def self._validate_svg_path(svg_path)
                raise Jekyll::Errors::FatalException, "SVG src does not exist in `#{svg_path}`" unless File.exist?(svg_path)
                svg_path
            end

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
                @svg_properties.each_pair do |svg_path, properties|
                    @rexml_spritesheet_properties[properties["spritesheet"]]["sprites"] ||= Set.new
                    rexml_svg = Util::REXMLHelpers.svg_to_rexml_svg(svg_path)
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
    
    end

end

