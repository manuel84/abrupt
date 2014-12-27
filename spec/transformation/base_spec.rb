require 'spec_helper'
# TODO: move to shared directory with a matching name
shared_examples 'convertable object' do

  let(:subject) do
    file = 'spec/fixtures/rikscha_min.xml'
    xml = Nokogiri::XML(File.read(file))
    values = Hash.from_xml(xml.to_s).deep_symbolize_keys!
    described_class.customize_to_schema(values)
  end
  let(:expected_values) do
    []
  end
  it 'part is converted' do
    keyname = described_class.name.split('::').last.downcase.to_sym
    actual = subject[:website][:url].map { |state| state[:state][keyname] }.compact
    expect(actual).to eql(expected_values)
  end
end
