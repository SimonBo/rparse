# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkFetcher do
  let(:fetcher) { LinkFetcher.new }

  describe '#fetch' do
    it 'fetches links to repos' do
      VCR.use_cassette 'link_fetcher/fetch_links' do
        result = fetcher.fetch
        expect(result.find { |l| l.include?('.tar.gz') }).to be_present
      end
    end
  end
end
