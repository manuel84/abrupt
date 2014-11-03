require 'spec_helper'
describe Abrupt::Converter, :vcr do
  context 'reading' do
    it 'from xml to correct hash' do
      crawled_hash = FactoryGirl.attributes_for :rikscha_old
      filename = 'spec/fixtures/rikscha_Result.xml'
      readed_hash = Abrupt::Converter.from_xml filename
      expect(crawled_hash[:data]).to eq(readed_hash)
    end

    it 'validates with schema' do
      filename = 'spec/fixtures/rikscha_min.xml'
      schema_filename = 'assets/schema/schema.json'
      readed_hash = Abrupt::Converter.from_xml filename
      puts readed_hash.to_json
      expect do
        JSON::Validator.validate!(schema_filename, readed_hash.to_json)
      end.not_to raise_error
    end
  end

  context 'converting' do
    it 'from hash to the correct repo' do
      crawled_hash = FactoryGirl.attributes_for :rikscha
      converted_repo = Abrupt::Converter.owl crawled_hash[:data]
      expected_repo = RDF::Repository.load(
          'spec/fixtures/rikscha-mainz.owl'
      )
      expect(converted_repo).to be_isomorphic_with(expected_repo)
    end
    it 'from xml to the correct repo' do
      crawled_hash = FactoryGirl.attributes_for :rikscha
      converted_repo = Abrupt::Converter.owl crawled_hash[:data]
      expected_repo = RDF::Repository.load(
          'spec/fixtures/rikscha-mainz.owl'
      )
      expect(converted_repo).to be_isomorphic_with(expected_repo)
    end
  end

end
