require 'spec_helper'
describe Abrupt::Converter, :vcr do
  it 'converts to correct repo' do
    crawled_hash = FactoryGirl.attributes_for :rikscha
    converted_repo = Abrupt::Converter.owl crawled_hash[:data]
    expected_repo = RDF::Repository.load(
        'spec/fixtures/rikscha-mainz.owl'
    )
    expect(converted_repo).to be_isomorphic_with(expected_repo)
  end

end
