# frozen_string_literal: true

require "jekyll"
require_relative "configuration"
require_relative "sprite"

module Jekyll
  module Sprites
    # Provides the liquid tag for the plugin.
    # Provides the svg properties to the SpritesheetGenerator instance stored in Configuration.
    # Renders the sprite html with a url placeholder which is replaced after spritesheet generation.
    class SpriteTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        @markup = markup
        _validate_markup
        @attributes = _parse_attributes
        super
      end

      def render(context)
        @config = context.registers[:site].config
        @sprites = _get_sprites
        @sprite = _get_sprite
        @sprite.register_page(context["page"]["path"])
        _update_sprites
        @sprite.get_html
      end

      def _get_sprite
        @sprites.find { |sprite| sprite.attributes == @attributes && sprite.pages.include?(@page_path) } ||= (
          new_sprite = Sprite.new(@attributes, @config)
          @sprites << new_sprite
          new_sprite
        )
      end

      def _get_sprites
        Configuration.get(@config, %w[sprites sprites])
      end

      def _update_sprites
        Configuration.set(@config, %w[sprites sprites], @sprites)
      end


      def _validate_markup
        attributes_pattern = /\A\s*[a-zA-Z][\w-]*\s*=\s*(['"][^'"]+['"])
          \s*(?:[a-zA-Z][\w-]*\s*=\s*(['"][^'"]+['"])\s*)*\z/x
        return if attributes_pattern.match?(@markup)

        raise Jekyll::Errors::FatalException,
              "Invalid HTML attributes format in `#{@markup}`"
      end

      def _parse_attributes
        attributes = {}
        @markup.scan(/(\w+)\s*=\s*('[^']*'|"[^"]*"|\S+)/) do |key, value|
          value = value[1..-2] if value.start_with?("'") || value.start_with?("\"")
          attributes[key] = value
        end

        attributes
      end

    end
  end
end

Liquid::Template.register_tag(Configuration.get("default", %w[sprites tag_name]), SpriteTag)