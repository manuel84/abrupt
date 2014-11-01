require 'spec_helper'
describe Abrupt::Crawler, :vcr do
  it 'outputs correct hash' do
    crawler = Abrupt::Crawler.new 'http://www.rikscha-mainz.de', lang: 'de'
    result = crawler.crawl
    expected_hash = FactoryGirl.attributes_for(:rikscha)[:data]
    expect(result).to eq(expected_hash)
  end

end
