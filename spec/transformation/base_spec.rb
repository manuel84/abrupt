require 'spec_helper'

shared_examples 'transformable object' do |key, value, expected_transformation, type|
  let(:values) do
    values = {
        base: {
            example: {
                key: {
                    string_value: 'hallo',
                    boolean_value: 'present',
                    integer_value: '-2',
                    float_value: '3.14',
                    array_string_values: ['hallo', 'Welt', 3],
                    array_boolean_values: [true, false, nil, 'present'],
                    array_integer_values: [-3, '1'],
                    array_float_values: ['1.4', 3]
                },
                simple_string: 'tada'
            }
        }
    }
  end
  it "the reference is transformed to #{key}" do
    subject.update_value([:example, :key, key], value, {type: type})
    expect(subject.values[:base][:example][:key][key]).to eql(expected_transformation)
    subject.values[:base][:example][:key].delete key
    values[:base][:example][:key].delete key
    expect(subject.values).to eql(values)
  end
end

describe Abrupt::Transformation::Base do

  let(:subject) do
    website = %w(Website http://www.dudda-und-dudda.de)
    page = %w(Page kontakt)
    Abrupt::Transformation::Base.new(website, page, values.dup)
  end
  it_should_behave_like 'transformable object', :string_value, 'Welt', 'Welt', :string
  it_should_behave_like 'transformable object', :boolean_value, 'present', true, :boolean
  it_should_behave_like 'transformable object', :integer_value, '-2', -2, :integer
  it_should_behave_like 'transformable object', :float_value, '3.14', 3.14, :number
  it_should_behave_like 'transformable object', :array_string_values, ['hallo', 'Welt', 3], %w(hallo Welt 3), :string
  it_should_behave_like 'transformable object', :array_boolean_values, [true, false, nil, 'present'], Array.new(4, true), :boolean
  it_should_behave_like 'transformable object', :array_integer_values, [-3, '1'], [-3, 1], :integer
  it_should_behave_like 'transformable object', :array_float_values, ['1.4', 3], [1.4, 3.0], :number

end
