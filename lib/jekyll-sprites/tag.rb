require "jekyll"
require_relative "configuration"


module Jekyll

    module Sprites
    
        class Tag < Liquid::Tag

            def initialize(tag_name, markup, tokens)
                markup = Tag._validate_markup(markup)
                attributes = Tag._parse_attributes(markup)
                @attributes = Tag._validate_attributes(attributes)
                @svg_rel_path = attributes.delete("src")
                super
            end

            def render(context)
                site = context.registers[:site]
                page_path = context["page"]["path"]
                svg_path = File.join(Configuration.get(site.config, ["sprites", "svg_dir"]), @svg_rel_path)
                spritesheet_generator = Configuration.get(site.config, ["sprites", "spritesheet_generator"])
                spritesheet_generator.set_svg_properties(svg_path, page_path)
                attributes_string = @attributes.map { |key, value| "#{key}=\"#{value}\"" }.join(" ")
                base_url = Tag._generate_base_url(Configuration.get(site.config, "baseurl"), page_path)
                url_placeholder = spritesheet_generator.get_url_placeholder(svg_path, page_path)
                sprite_id = File.basename(svg_path, '.*')
                sprite_html = <<-STRING
                <svg #{attributes_string} >
                    <use href=\"#{base_url}#{url_placeholder}##{sprite_id}\"></use>
                </svg>
                STRING
                Tag._unindent_string(sprite_html)
            end

            private

            def self._validate_markup(markup)
                attributes_pattern = /\A\s*[a-zA-Z][\w-]*\s*=\s*(['"][^'"]+['"])\s*(?:[a-zA-Z][\w-]*\s*=\s*(['"][^'"]+['"])\s*)*\z/
                raise Jekyll::Errors::FatalException, "Invalid HTML attributes format in `#{markup}`" unless attributes_pattern.match?(markup)
                markup
            end

            def self._validate_attributes(attributes)
                raise Jekyll::Errors::FatalException, "No SVG src provided in `#{attributes}`" unless attributes.keys.include?("src")
                attributes
            end

            def self._parse_attributes(markup)
                attributes = {}
                markup.scan(/(\w+)\s*=\s*('[^']*'|"[^"]*"|\S+)/) do |key, value|
                value = value[1..-2] if value.start_with?("'") || value.start_with?("\"")
                attributes[key] = value
                end
                attributes
            end

            def self._generate_base_url(base_url, page_path)
                path_modifier = "../" * page_path.count("/")
                base_url = path_modifier == "" ? base_url.sub(/\/+$/, '')+"/" : path_modifier
                base_url
            end

            def self._unindent_string(string)
                string.gsub(/^#{string.scan(/^[ \t]+(?=\S)/).min}/, '')
            end

        end    
    
    end

end
