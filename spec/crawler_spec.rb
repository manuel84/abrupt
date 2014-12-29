require 'spec_helper'
describe Abrupt::Crawler, :vcr do
  it 'outputs correct hash', beta: true do
    pending 'out of development'
    crawler = Abrupt::Crawler.new 'http://www.rikscha-mainz.de', lang: 'de'
    result = crawler.crawl
    expected_hash = FactoryGirl.attributes_for(:rikscha)
    expected_hash = expected_hash.deep_symbolize_keys[:data]
    expect(result).to eq(expected_hash)
  end

end
