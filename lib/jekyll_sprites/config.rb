require 'jekyll'

module Config

    DEFAULTS = {
        "tag_name" => "sprite",
        "svg_dir" => "_sprites",
        "spritesheet_dir" => "assets/images/spritesheets"
    }.freeze

    def self.get(config, keys)
        keys = Array(keys)
        if config == "default"
            puts("---")
            puts(config)
            puts(DEFAULTS)
            puts(DEFAULTS.dig(*keys))
            puts("---")
            value = DEFAULTS.dig(*keys)
        else
            value = config.dig(*["sprites"]+keys) || DEFAULTS.dig(*keys)
        end
        value
    end

    def self.set(config, keys, value)
        keys = ["sprites"]+Array(keys)
        last_key = keys.pop
        target_hash = keys.reduce(config) { |hash, key| hash[key] ||= {} }
        target_hash[last_key] = value
    end

end