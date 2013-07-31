require_relative 'data_helper'
require_relative 'markdown_helper'

module ApiHelper

  include DataHelper
  include MarkdownHelper

  def api_methods
    load_api_methods.map{|a| expand_api_markdown(a)}
  end

  private

  def expand_api_markdown(meth)
    meth['description'] = md_to_html(meth['description'])
    meth['signature'] = meth['signature'].map do |param|
      param['description'] = md_to_html(param['description'])
      param
    end
    meth
  end

  def load_api_methods
    site_data('api_methods')
  end

end
