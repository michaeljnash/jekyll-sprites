require 'jekyll'
require_relative 'tag'
require_relative 'hook_actions'

module Registrars

    def self.register_all()
        self.register_liquid_tags()
        self.register_jekyll_hooks()
    end

    def self.register_liquid_tags()
        Liquid::Template.register_tag(CONFIG["tag_name"], Tag)
    end

    def self.register_jekyll_hooks()
        Jekyll::Hooks.register :site, :after_reset, &HookActions.method(:reset)
        Jekyll::Hooks.register :site, :post_render, &HookActions.method(:generate_spritesheets)
        Jekyll::Hooks.register :site, :post_render, &HookActions.method(:update_page_spritesheet_urls)
        Jekyll::Hooks.register :site, :post_write, &HookActions.method(:write_spritesheets)
    end

end