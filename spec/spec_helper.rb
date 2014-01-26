require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'tmpdir'

def api_params(fields)
  h.api_methods.map do |m|
    m['signature']
  end.flatten.select do |param|
    (fields.to_a - param.to_a).empty?
  end
end

def helper_with_api_method(options={})
  Object.extend(ApiHelper).tap do |h|
    h.instance_eval do
      @options = options
      def load_api_methods
        [{
          'description' => @options[:description],
          'signature' => [{'description' => @options[:param_description]}]
        }]
      end
    end
  end
end

def well_formed_ruby?(code_string)
  begin
    eval "def fc_well_formed\n#{code_string}\nend"
    true
  rescue SyntaxError
    false
  end
end
