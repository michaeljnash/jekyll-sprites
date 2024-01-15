# frozen_string_literal: true

require "jekyll"
require_relative "jekyll_sprites/version"
require_relative "jekyll_sprites/registration"


module Jekyll
  module Sprites
    Registration.register_all
  end
end
