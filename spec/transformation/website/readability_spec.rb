require_relative '../base_spec'

describe Abrupt::Transformation::Website::Readability do
  it_should_behave_like 'convertable object' do
    let(:expected_values) do
      [{ :readability => 5.288413836478,
         :syllables => 395,
         :words => 225,
         :numberOfLinks => 12,
         :bigwords => 48,
         :sentences => 53,
         :language => "de" },
       { :readability => 5.1171449882608,
         :syllables => 399,
         :words => 226,
         :numberOfLinks => 13,
         :bigwords => 46,
         :sentences => 49,
         :language => "de" }]
    end
  end
end
