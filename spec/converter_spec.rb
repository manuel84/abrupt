require 'spec_helper'
describe Abrupt::Converter, :vcr do
  let(:subject) do
    Abrupt::Converter.instance.init('spec/fixtures/rikscha_min.xml')
    Abrupt::Converter.instance
  end
  context '#from_xml' do
    it 'should convert to hash with customized datatypes' do
      crawled_hash = FactoryGirl.attributes_for(:rikscha_website_data)
      crawled_hash = crawled_hash.deep_symbolize_keys[:data]
      expect(subject.hsh).to eql(crawled_hash)
    end

    it 'should validates with json schema' do
      schema_filename = 'assets/schema/schema.json'
      expect do
        JSON::Validator.validate!(schema_filename, subject.hsh.to_json)
      end.not_to raise_error
    end
  end

  context 'converting' do
    it 'from hash to the correct repo' do
      pending 'dev'
      crawled_hash = FactoryGirl.attributes_for(:rikscha_converted)
      converted_repo = Abrupt::Converter.to_repository crawled_hash
      expected_repo = RDF::Repository.load(
          'spec/fixtures/rikscha-mainz.ttl'
      )
      expect(converted_repo).to be_isomorphic_with(expected_repo)
    end
  end
end
