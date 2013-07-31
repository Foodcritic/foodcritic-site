require_relative 'spec_helper'
require_relative '../helpers/rule_helper'

describe RuleHelper do

  describe "#rules" do
    let(:h){ Object.extend(RuleHelper) }
    describe :basic_properties do
      it "is non-empty set of rules" do
        h.rules.wont_be_empty
      end
      it "has no duplicate codes" do
        codes = h.rules.map{|r| r['code']}
        codes.must_equal codes.uniq
      end
      it "has no duplicate names" do
        names = h.rules.map{|r| r['name']}
        names.must_equal names.uniq
      end
      it "is sorted by rule code" do
        h.rules.must_equal h.rules.sort_by{|r| r['code']}
      end
    end
    describe :examples do
      it "has positive and negative examples per rule" do
        h.rules.select{|r| r['examples'].count.odd?}.must_be_empty
      end
      it "are syntactically valid ruby code" do
        h.rules.each do |rule|
          rule['examples'].each_with_index do |example, i|
            assert well_formed_ruby?(example['code']),
              "Rule #{rule['code']} example #{i} malformed:\n#{example['code']}"
          end
        end
      end
    end
    describe :markdown_expansion do
      let(:h) do
        helper_with_rule :summary => 'foo *bar*',
          :example => 'An example with `markdown`'
      end
      it "expands markdown in the rule summary" do
        h.rules.first['summary'].must_equal("<p>foo <em>bar</em></p>\n")
      end
      it "expands markdown in the example text" do
        h.rules.first['examples'].first['text'].must_equal(
          "<p>An example with <code>markdown</code></p>\n")
      end
    end
  end

  describe "#rule_count" do
    let(:h) do
      Object.new.extend(RuleHelper).tap do |h|
        h.instance_eval do
          def load_rules
            [
              {'summary' => 'rule 1'},
              {'summary' => 'rule 2'},
              {'summary' => 'rule 3', 'deprecated' => true},
              {'summary' => 'rule 4'}
            ]
          end
        end
      end
    end
    it "does not include deprecated rules in the rule count total" do
      h.rule_count.must_equal 3
    end
  end

end
