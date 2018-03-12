require_relative "spec_helper"
require_relative "../helpers/api_helper"

describe ApiHelper do

  describe "#api_methods" do
    let(:h) { Object.extend(ApiHelper) }
    describe :basic_properties do
      it "is non-empty set of methods" do
        h.api_methods.wont_be_empty
      end
      it "lists the api methods in alphabetical order" do
        meths = h.api_methods.map { |m| m["name"] }
        meths.must_equal meths.sort
      end
      it "does not duplicate methods" do
        meths = h.api_methods.map { |m| m["name"] }
        meths.must_equal meths.uniq
      end
      it "specifies arguments using known categories" do
        param_categories = h.api_methods.map do |m|
          m["signature"].map { |p| p["category"] }
        end.flatten.sort.uniq
        param_categories.must_equal %w{option param return}
      end
      it "provides a name for all parameters" do
        api_params("category" => "param").each { |p| p["name"].wont_be_empty }
      end
      it "provides a description for all parameters" do
        api_params("category" => "param").each do |p|
          p["description"].wont_be_empty
        end
      end
      it "does not provide a name for return values" do
        api_params("category" => "return").each { |p| refute p["name"] }
      end
    end
    describe :markdown_expansion do
      let(:h) do
        helper_with_api_method :description => "[Google](http://google.com/)",
                               :param_description => "One of `:foo` or `:baz`"
      end
      it "expands markdown in the method description" do
        h.api_methods.first["description"].must_equal(
          %Q{<p><a href="http://google.com/">Google</a></p>\n})
      end
      it "expands markdown in the parameter description" do
        h.api_methods.first["signature"].first["description"].must_equal(
          "<p>One of <code>:foo</code> or <code>:baz</code></p>\n")
      end
    end
  end

end
