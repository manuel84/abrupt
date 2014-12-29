require 'spec_helper'
# TODO: move to shared directory with a matching name
shared_examples 'convertable object' do

  let(:subject) do
    file = 'spec/fixtures/rikscha_min.xml'
    xml = Nokogiri::XML(File.read(file))
    values = Hash.from_xml(xml.to_s).deep_symbolize_keys![:website][:url]
    values.map { |states| described_class.customize_to_schema(states) }
  end
  let(:expected_values) do
    []
  end
  it 'part is converted' do
    keyname = described_class.name.split('::').last.downcase.to_sym
    actual = subject.map { |s| s[:state][keyname] }.compact
    expect(actual).to eql(expected_values)
  end
end
