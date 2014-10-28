require 'spec_helper'
describe Abrupt::Crawler, :vcr do
  it 'outputs correct hash' do
    crawler = Abrupt::Crawler.new 'http://www.dudda-und-dudda.de', lang: 'de'
    result = crawler.crawl
    expected_hash = {}
    expect(result).to eq(expected_hash)
  end

end
