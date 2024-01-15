require 'rexml/document'

module Jekyll

    module Sprites

        module Util

            module REXMLHelpers

                def self.update_rexml_attributes(rexml_element, attributes)
                    attributes.each_pair do |attribute, value|
                        unless rexml_element[attribute.to_s]
                            rexml_element.add_attribute(attribute.to_s, value.to_s)
                        else
                            rexml_element.attributes[attribute.to_s] = value.to_s
                        end
                    end
                end

                def self.create_rexml_element(tag, attributes)
                    rexml_element = REXML::Element.new(tag)
                    self.update_rexml_attributes(rexml_element, attributes)
                    rexml_element
                end

                def self.svg_to_rexml_svg(svg_path)
                    svg_data = File.read(svg_path)
                    rexml_svg_doc = REXML::Document.new(svg_data)
                    rexml_svg = rexml_svg_doc.elements['svg']
                    self.update_rexml_attributes(rexml_svg, {"id": File.basename(svg_path, '.*')})
                    rexml_svg
                end

                def self.rexml_svg_to_rexml_sprite(rexml_svg)
                    rexml_sprite = self.create_rexml_element("symbol", {
                        "id": rexml_svg.attributes['id'],
                        "viewBox": rexml_svg.attributes['viewBox']
                    })
                    rexml_svg.delete_attribute('id').delete_attribute('viewBox')
                    rexml_sprite.add_element(rexml_svg.deep_clone)
                    rexml_sprite
                end

                def self.write_rexml_to_file(file_path, rexml)
                    file_data = REXML::Formatters::Pretty.new(2).write(rexml, '')
                    unless File.exist?(file_path) && file_data == File.read(file_path)
                        File.write(file_path, file_data)
                    end
                end

            end

        end

    end

end
