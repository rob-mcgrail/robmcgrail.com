module TemplateHelpers
  # Only expanding these as I need them...

  module Core

    def link_to(url, text)
      "<a href='#{url}'>#{text}</a>"
    end

    def image_tag(path, opts={})
      alt = opts[:alt] || ''
      cls = opts[:class] || ''

      "<img src='#{path}' alt='#{alt}' class='#{cls}'>"
    end

  end # module Includes
end

