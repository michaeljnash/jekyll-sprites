# frozen_string_literal: true

require "fileutils"
require "zlib"
require "jekyll"
require "stringio"
require_relative "util"
require_relative "configuration"

module Jekyll
  module Sprites
    # Provides methods to set svg properties from Tag class, and then generate and write all spritesheets.
    # Provides methods to get url placeholders, and update url placeholders (after render).
    class SpritesheetGenerator < Jekyll::Generator #might not have ot specify jekyll
      
      def generate(site)
        @config = site.config
        @dest = site.dest
        @sprites = _get_sprites
        @spritesheets = _get_spritesheets
        _add_sprites_to_spritesheets
        _generate_spritesheets
      end

      private

      def _get_sprites
        Configuration.get(@config, %w[sprites sprites])
      end
      
      def _get_spritesheets
        Configuration.get(@config, %w[sprites spritesheets])
      end

      def _get_spritesheet_dir
        spritesheet_dir = Configuration.get(@config, %w[sprites spritesheet_dir])
      end

      def _get_indentation
        Configuration.get(@config, %w[sprites spritesheet_dir])
      end

      def _add_sprites_to_spritesheets
        @sprites.each do |sprite|
          spritesheet_name = sprite.get_spritesheet_name
          spritesheet = @spritesheets.find { |spritesheet| spritesheet.name == spritesheet_name } ||= (
            new_spritesheet = Spritesheet.new(spritesheet_name)
            @spritesheets << new_spritesheet
            new_spritesheet
          )
          spritesheet.add_sprite(sprite)
        end
      end

      def _generate_spritesheets
        @spritesheets.each do |spritesheet|
          rexml_spritesheet = spritesheet.get_rexml
          indentation = _get_indentation
          spritesheet_dir = _get_spritesheet_dir
          spritesheet_path = File.join(@dest, spritesheet_dir, spritesheet.name, ".svg")
          xml = REXML::Formatters::Pretty.new(indentation).write(rexml_spritesheet, StringIO.new)
          return if File.exist?(spritesheet_path) && xml == File.read(spritesheet_path)
          FileUtils.mkdir_p(spritesheet_path)
          File.write(xml, spritesheet_path)
        end
      end

    end
  end
end
