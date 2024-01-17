

module Jekyll
  module Sprites
    # 
    module Hooks

      extend self

      def register
        Jekyll::Hooks.register :site, :post_render do |site|
          _update_url_placeholders
        end
      end

      private

      def _update_url_placeholders
        sprites = _get_sprites(site.config)
        site.pages.each do |page|
          sprites.each do |sprite|
            next unless sprite.pages.include?(page.path)
            spritesheet_dir = _get_spritesheet_dir(site.config)
            spritesheet_path = File.join(spritesheet_dir, sprite.get_spritesheet_name)
            url_placeholder = sprite.get_url_placeholder(page.path)
            updated_content = page.output.gsub(url_placeholder, spritesheet_path)
            page.output = updated_content
          end
        end
      end

      def _get_sprites(config)
        Configuration.get(config, %w[sprites sprites])
      end

      def _get_spritesheet_dir(config)
        Configuration.get(config, %w[sprites spritesheet_dir])
      end

    end
  end
end

Jekyll::Sprites::Hooks.register