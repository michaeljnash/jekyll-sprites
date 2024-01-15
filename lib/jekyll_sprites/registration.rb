require 'jekyll'
require_relative 'tag'
require_relative 'spritesheet_generator'
require_relative 'config'

module Jekyll

    module Sprites

        module Registration

            def self.register_all()
                self._register_liquid_tags()
                self._register_jekyll_hooks()
            end

            private

            def self._register_liquid_tags()
                Liquid::Template.register_tag(Config.get("default", ["sprites", "tag_name"]), Tag)
            end

            def self._register_jekyll_hooks()
                Jekyll::Hooks.register :site, :after_reset do |site|
                    Configuration.set(site.config, ["sprites", "spritesheet_generator"], SpritesheetGenerator.new)
                end
                Jekyll::Hooks.register :site, :post_render do |site|
                    Configuration.get(site.config, ["sprites", "spritesheet_generator"]).generate()
                end
                Jekyll::Hooks.register :site, :post_render do |site|
                    Configuration.get(site.config, ["sprites", "spritesheet_generator"]).update_url_placeholders(site)
                end
                Jekyll::Hooks.register :site, :post_write do |site|
                    Configuration.get(site.config, ["sprites", "spritesheet_generator"]).write(site)
                end
            end

        end

    end
    
end
