module Jekyll
  class FilePath < Liquid::Tag
    @markup = nil

    def initialize(tag_name, markup, tokens)
      @markup = markup.strip
      super
    end

    def render(context)
      if @markup.empty?
        return "Expected syntax {% filepath [filename] %}"
      end

      rawFilename = Liquid::Template.parse(@markup).render context
      filename = rawFilename.gsub(/^("|')|("|')$/, '')
      path = ""
      page = context.environments.first["page"]

      if page["id"]
        context.registers[:site].posts.each do |post|
          if post.id == page["id"]
            path = "#{post.relative_path}".gsub(/_posts/, '').gsub(/.md/, '')
          end
        end
      else
        path = page["url"]
      end

      path = File.dirname(path) if path =~ /\.\w+$/
      "/files/#{path}/#{filename}".gsub(/\/{2,}/, '/')
    end
  end
end

Liquid::Template.register_tag('filepath', Jekyll::FilePath)
