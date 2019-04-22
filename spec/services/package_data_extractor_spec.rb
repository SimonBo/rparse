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

  describe '#package_names' do
    it 'gets package names from site' do
      VCR.use_cassette 'package_data_extractor/fetch_package_names' do
        result = extractor.fetch_package_names
        expect(result).to be_instance_of Array
        expect(result).to include 'A3'
      end
    end
  end
end
