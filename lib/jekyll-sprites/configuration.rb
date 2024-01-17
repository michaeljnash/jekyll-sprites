# frozen_string_literal: true

require "jekyll"

module Jekyll
  module Sprites
    # Provides jekyll configuration set and get methods with DEFAULT as fallback.
    # If get is passed "default" for config, it will access DEFAULT directly.
    # TODO: add validation for config somehow
    module Configuration
      DEFAULT = {
        "sprites" => {
          "tag_name" => "sprite",
          "indentation" => "2"
          "svg_dir" => "_sprites",
          "spritesheet_dir" => "assets/images/spritesheets"
          "spritesheet_attributes" => {
              "width": "0",
              "height": "0",
              "class": "hidden",
              "xmlns": "http://www.w3.org/2000/svg",
              "xmlns:xlink": "http://www.w3.org/1999/xlink"
            }
        }
      }.freeze

      def self.get(config, keys)
        keys = Array(keys)
        config == "default" ? DEFAULT.dig(*keys) : config.dig(*keys) || DEFAULT.dig(*keys)
      end

      def self.set(config, keys, value)
        keys = Array(keys)
        last_key = keys.pop
        keys.reduce(config) { |hash, key| hash[key] ||= {} }[last_key] = value
      end
    end
  end
end
