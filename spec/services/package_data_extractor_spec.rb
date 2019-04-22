# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageDataExtractor do
  let(:extractor) { PackageDataExtractor.new }

  describe '#data' do
    it 'fetches data from links' do
      VCR.use_cassette 'A3' do
        extractor = PackageDataExtractor.new(links: ['A3_1.0.0.tar.gz'], package_names: ['A3'])
        result = extractor.data
        expect(result.size).to eq 1
        expect(result.first).to be_instance_of Hash
        expect(result.first[:authors]).to eq 'Scott Fortmann-Roe'
      end
    end
  end
end
