# frozen_string_literal: true

require "jekyll"
require_relative "jekyll-sprites/version"
require_relative "jekyll-sprites/registration"

module Jekyll
  module Sprites
    include Hooks #needed?
  end
end
