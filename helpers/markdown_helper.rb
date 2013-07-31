require 'kramdown'

module MarkdownHelper

  def md_to_html(md)
    Kramdown::Document.new(md).to_html
  end

end
