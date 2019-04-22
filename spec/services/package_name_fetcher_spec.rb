# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageNameFetcher do
  let(:fetcher) { PackageNameFetcher.new }

  describe '#fetch' do
    it 'fetches package_names' do
      VCR.use_cassette 'package_name_fetcher/fetch' do
        result = fetcher.fetch
        expect(result).to be_instance_of Array
        expect(result).to include 'A3'
      end
    end
  end
end
