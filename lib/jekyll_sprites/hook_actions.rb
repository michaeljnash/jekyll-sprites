require 'jekyll'
require_relative 'spritesheets_generator'

module HookActions

    def self.reset(site)
        site.config[:spritesheet_generator] = SpritesheetsGenerator.new #try find a way to maybe access the jekyll site object in plugin initialisation? then do every reset somehow?
    end

    def self.generate_spritesheets(site, payload)
        site.config[:spritesheet_generator].generate()
    end

    def self.update_page_spritesheet_urls(site, payload)
        site.pages.each do |page|
            svg_properties=site.config[:spritesheet_generator].get_svg_properties()
            svg_properties.each_value do |properties|
                if properties["pages"].keys.include?(page.path)
                    updated_content = page.output.gsub(properties["pages"][page.path], File.join(CONFIG["spritesheets_dir"], properties["spritesheet"])) #wont work for nested pages
                    page.output = updated_content
                end
            end
        end
    end

    def self.write_spritesheets(site)
        spritesheets_dest = File.join(site.dest, CONFIG["spritesheets_dir"])
        site.config[:spritesheet_generator].write(spritesheets_dest)
    end

end