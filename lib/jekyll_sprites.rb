# frozen_string_literal: true

require_relative "jekyll_sprites/version"
require_relative "jekyll_sprites/registrars"


CONFIG = {
  "svgs_dir": "_sprites"
  "spritesheets_dir": "/assets/images/spritesheets"
  "tag_name": "sprites"
}

module JekyllSprites
  class Error < StandardError; end
  Registrars.register_all()
end
