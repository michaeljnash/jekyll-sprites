require_relative "util"
require_relative "config"
require_relative "spritesheets_generator"
require_relative "hook_actions"

class Tag < Liquid::Tag

    def initialize(tag_name, input, tokens)
        @svg_rel_path, @class_names = input.split('||').map(&:strip)
        @sprite_id = File.basename(@svg_rel_path, '.*')
        #validate! for .svg, for length of args...
        super
    end

    def render(context)
        site = context.registers[:site]
        Config.get(site.config, "spritesheet_generator").add_svg_properties(@svg_rel_path, context["page"]["path"]) #maybe pass full svg path instead??? do away with relpath?
        use_sprite_html = <<-STRING
        <svg class=\"#{@class_names}\" role=\"img\" alt=#{@sprite_id}>
            <use xlink:href=\"#{Config.get(site.config, "spritesheet_generator").get_url_replacement_id(@svg_rel_path, context["page"]["path"])}##{@sprite_id}\"></use>
        </svg>
        STRING
        Util::StringHelpers.unindent(use_sprite_html)
    end

end