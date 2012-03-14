STDERR.puts("################hoge!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
module Jekyll
  module BreadcrumbFilter
    def breadcrumb(url, stdout=false)
      def dirname(index, dir)
        if index == 0 then
          "Home"
        else
          dir
        end
      end

      activated = /\/index.html?$/.match(url)
      list = (url.split("/"))[0...-1]
      link = ""
      anchors = []
      list.each_with_index do|dir, index|
        link += "#{dir}/" 
        anchor = if (index == list.length - 1 and activated) then
          "<li class=\"active\">#{dirname index, dir}</li>"
        else
          "<li><a href=\"#{link}\">#{dirname index, dir}</a><span class=\"divider\">/</span></li>"
        end
        anchors.push(anchor)
      end
      "<ul class=\"breadcrumb\">\n#{
        anchors.join("\n")
      }\n</ul>"
    end
  end

end # Jekyll

Liquid::Template.register_filter(Jekyll::BreadcrumbFilter)
