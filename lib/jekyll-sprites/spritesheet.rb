class Spritesheet

    attr_reader :spritesheet_name

    def initialize(spritesheet_name, config)
      @config = config
      @spritesheet_name = spritesheet_name
      @sprites = Set.new
    end

    def add_sprite(sprite)
      @sprites.add(sprite)
    end

    def get_rexml
      attributes = _get_spritesheet_attributes
      rexml_spritesheet = REXML::Element.new("svg", attributes)
      @sprites.each do |sprite| #should change all rexml_sprite to sprite_rexml
        rexml_sprite = sprite.get_rexml
        rexml_spritesheet.add_element(rexml_sprite.deep_clone)
      end
      rexml_spritesheet
    end

    private

    def _get_spritesheet_attributes
      Configuration.get(@config, %w[sprites spritesheet_attributes])
    end


  end