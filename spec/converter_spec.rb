require 'spec_helper'
describe Abrupt::Converter, :vcr do
  it 'converts to correct owl' do
    crawled_hash = FactoryGirl.build :rikscha
    converted_xml = Abrupt::Converter.owl crawled_hash
    graph = RDF::Graph.load(
        'spec/fixtures/rikscha-mainz.owl'
    )
    expected_xml = graph.dump :rdfxml
    expect(converted_xml).to be_equivalent_to(expected_xml)
  end

end
