require 'jekyll'
require_relative 'tag'
require_relative 'config'
require_relative 'hook_actions'

module Registrars

    def self.register_all()
        self._register_liquid_tags()
        self._register_jekyll_hooks()
    end

    private

    def self._register_liquid_tags()
        Liquid::Template.register_tag(Config.get("default", "tag_name"), Tag) #doesnt have access to CONFIG variable -- actually get from _config.yml!! make util function to get config vars
    end

    def self._register_jekyll_hooks()
        Jekyll::Hooks.register :site, :after_reset, &HookActions.method(:reset)
        Jekyll::Hooks.register :site, :post_render, &HookActions.method(:generate_spritesheets)
        Jekyll::Hooks.register :site, :post_render, &HookActions.method(:update_page_spritesheet_urls)
        Jekyll::Hooks.register :site, :post_write, &HookActions.method(:write_spritesheets)
    end

end