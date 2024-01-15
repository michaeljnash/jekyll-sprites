# frozen_string_literal: true

require "jekyll"
require_relative "jekyll_sprites/version"
require_relative "jekyll_sprites/registration"


module Jekyll
  module Sprites
  end
end

Registration.register_all()
