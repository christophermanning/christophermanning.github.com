module Jekyll
  class VimeoTag < Liquid::Tag
    SYNTAX = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/

    def initialize(tag_name, markup, tokens)
      super

      if markup =~ SYNTAX
        @id = Regexp.last_match(1)

        if Regexp.last_match(2).nil?
          @width = 720
          @height = 405
        else
          @width = Regexp.last_match(2).to_i
          @height = Regexp.last_match(3).to_i
        end
      else
        fail "invalid syntax: #{markup}"
      end
    end

    def render(_context)
      # rubocop:disable Metrics/LineLength
      o = '<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style>'
      o += "<div class='embed-container'>"
      o += "<iframe class='lazyload' src='//player.vimeo.com/video/#{@id}?title=0&amp;byline=0&amp;portrait=0&amp;color=fff' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
      o += '</div>'
      o
      # rubocop:enable Metrics/LineLength
    end
  end
end

Liquid::Template.register_tag('vimeo', Jekyll::VimeoTag)
