require 'spec_helper'
describe Abrupt::Converter, :vcr do
  let(:website_data_file) { 'spec/fixtures/rikscha_Result_min.xml' }
  let(:website_repo_file) { 'spec/fixtures/rikscha-mainz.ttl' }
  before(:each) { Abrupt::Converter.instance.init }

  context '#append_website_data', broken_on_ci: true do
    it 'should convert to hash with customized datatypes' do
      crawled_hash = FactoryGirl.attributes_for(:rikscha_website_data)
      crawled_hash = crawled_hash.deep_symbolize_keys[:data]
      Abrupt::Converter.instance.append_website_data(website_data_file)
      expect(Abrupt::Converter.instance.hsh).to eql(crawled_hash)
    end

    it 'should validates with json schema' do
      schema_filename = 'assets/schema/schema.json'
      Abrupt::Converter.instance.append_website_data(website_data_file)
      expect do
        JSON::Validator.validate!(schema_filename,
                                  Abrupt::Converter.instance.hsh.to_json)
      end.not_to raise_error
    end
  end

  context 'converting' do
    it 'from hash to the correct repo' do
      pending 'dev'
      crawled_hash = FactoryGirl.attributes_for(:rikscha_converted)
      converted_repo = Abrupt::Converter.to_repository crawled_hash
      expected_repo = RDF::Repository.load(website_repo_file)
      expect(converted_repo).to be_isomorphic_with(expected_repo)
    end
  end
end
