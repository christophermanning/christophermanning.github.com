module Jekyll
  require 'haml'
  class HamlConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /haml/i
    end

    def output_ext(_ext)
      '.html'
    end

    def convert(content)
      engine = Haml::Template.new { content }
      engine.render
    rescue StandardError => e
      puts '!!! HAML Error: ' + e.message
    end
  end
end
