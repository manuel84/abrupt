require 'spec_helper'
describe Abrupt::Converter, :vcr do
  context 'reading' do
    it 'from xml to correct hash' do
      crawled_hash = FactoryGirl.attributes_for(:rikscha_old)
      crawled_hash = crawled_hash.deep_symbolize_keys[:data]
      filename = 'spec/fixtures/rikscha_Result.xml'
      readed_hash = Abrupt::Converter.from_xml filename
      expect(readed_hash).to eq(crawled_hash)
    end

    it 'validates with schema' do
      filename = 'spec/fixtures/rikscha_min.xml'
      schema_filename = 'assets/schema/schema.json'
      readed_hash = Abrupt::Converter.from_xml filename
      expect do
        JSON::Validator.validate!(schema_filename, readed_hash.to_json)
      end.not_to raise_error
    end
  end

  context 'converting' do
    it 'from hash to the correct repo' do
      crawled_hash = FactoryGirl.attributes_for(:rikscha)
      crawled_hash = crawled_hash.deep_symbolize_keys[:data]
      converted_repo = Abrupt::Converter.to_repository crawled_hash
      expected_repo = RDF::Repository.load(
          'spec/fixtures/rikscha-mainz.owl'
      )
      expect(converted_repo).to be_isomorphic_with(expected_repo)
    end
    it 'from xml to the correct repo' do
      pending 'pending'
      crawled_hash = FactoryGirl.attributes_for(:rikscha)
      crawled_hash = crawled_hash.deep_symbolize_keys[:data]
      converted_repo = Abrupt::Converter.to_repository crawled_hash
      expected_repo = RDF::Repository.load(
          'spec/fixtures/rikscha-mainz.owl'
      )
      expect(converted_repo).to be_isomorphic_with(expected_repo)
    end
  end

end
