require 'jekyll'


module Jekyll

    module Sprites
    
        module Configuration

            DEFAULT = {
                "sprites" => {
                    "tag_name" => "sprite",
                    "svg_dir" => "_sprites",
                    "spritesheet_dir" => "assets/images/spritesheets"
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
