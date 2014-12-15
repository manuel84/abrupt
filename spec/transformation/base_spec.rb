require 'spec_helper'

describe Abrupt::Transformation::Base do
  let(:values) do
    values = {
        base: {
            example: {
                key: {
                    string_value: 'hallo',
                    float_value: '3.14',
                    integer_value: '-2',
                    boolean_value: 'present',
                    array_string_values: %w(hallo Welt),
                    array_float_values: ['1.4', 3],
                    array_float_values: [-3, '1'],
                    array_boolean_values: [true, false, nil, 'present']
                },
                simple_string: 'tada'
            }
        }
    }
  end
  let(:subject) do
    website = %w(Website http://www.dudda-und-dudda.de)
    page = %w(Page kontakt)
    Abrupt::Transformation::Base.new(website, page, values.dup)
  end
  context '#update_value' do
    context 'array values' do
      it 'transforms the references to strings' do
      end
      it 'transforms the references to booleans' do

      end
      it 'transforms the references to integers' do

      end
      it 'transforms the references to floats' do

      end
    end
    context 'single value' do
      it 'transforms the reference to a string' do
        subject.update_value([:example, :key, :string_value], 'Welt', {type: :string})
        expect(subject.values[:base][:example][:key][:string_value]).to eql('Welt')
        subject.values[:base][:example][:key].delete :string_value
        values[:base][:example][:key].delete :string_value
        expect(subject.values).to eql(values)
      end
      it 'transforms the reference to a boolean' do
        subject.update_value([:example, :key, :boolean_value], 'present', {type: :boolean})
        expect(subject.values[:base][:example][:key][:boolean_value]).to be_truthy
        subject.values[:base][:example][:key].delete :boolean_value
        values[:base][:example][:key].delete :boolean_value
        expect(subject.values).to eql(values)
      end
      it 'transforms the reference to a integer' do
        subject.update_value([:example, :key, :integer_value], -2, {type: :integer})
        expect(subject.values[:base][:example][:key][:integer_value]).to eql(-2)
        subject.values[:base][:example][:key].delete :integer_value
        values[:base][:example][:key].delete :integer_value
        expect(subject.values).to eql(values)
      end
      it 'transforms the reference to a float' do
        subject.update_value([:example, :key, :float_value], '3.14', {type: :number})
        expect(subject.values[:base][:example][:key][:float_value]).to eql(3.14)
        subject.values[:base][:example][:key].delete :float_value
        values[:base][:example][:key].delete :float_value
        expect(subject.values).to eql(values)
      end
    end

  end
end
