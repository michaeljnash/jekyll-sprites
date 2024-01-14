require 'jekyll'
require_relative 'config'
require_relative 'spritesheet_generator'

module HookActions

    def self.reset(site)
        #should have a config set as well for this.
        Config.set(site.config, "spritesheet_generator", SpritesheetGenerator.new)
        #site.config[:spritesheet_generator] = SpritesheetGenerator.new #try find a way to maybe access the jekyll site object in plugin initialisation? then do every reset somehow?
    end

    def self.generate_spritesheets(site, payload)
        Config.get(site.config, "spritesheet_generator").generate()
        #site.config[:spritesheet_generator].generate()
    end

    def self.update_page_spritesheet_urls(site, payload)
        site.pages.each do |page|
            svg_properties=Config.get(site.config, "spritesheet_generator").get_svg_properties()
            svg_properties.each_value do |properties|
                if properties["pages"].keys.include?(page.path)
                    updated_content = page.output.gsub(properties["pages"][page.path], File.join(Config.get(site.config, "spritesheet_dir"), properties["spritesheet"])) #wont work for nested pages
                    page.output = updated_content
                end
            end
        end
    end

    def self.write_spritesheets(site)
        spritesheet_dest = File.join(site.dest, Config.get(site.config, "spritesheet_dir"))
        Config.get(site.config, "spritesheet_generator").write(spritesheet_dest)
    end

end