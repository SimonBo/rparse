# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepoParser do
  let(:entry) do
    {
      name: 'A3',
      description: 'abc',
      title: 'abc',
      authors: 'abc',
      version: 'abc',
      maintainers: 'abc',
      license: 'abc',
      publication_date: DateTime.new
    }
  end
  let(:parser) { RepoParser.new(links_array: [['some_link']]) }
  
  describe '#refresh_repos' do
    it 'creates new packages' do
      expect(Package.count).to eq 0
      
      allow(parser).to receive(:data).with(['some_link']) { [entry] }
      parser.refresh_repos
      
      expect(Package.count).to eq 1
      pck = Package.first
      expect(pck.name).to eq entry[:name]
      expect(pck.description).to eq entry[:description]
      expect(pck.title).to eq entry[:title]
      expect(pck.authors).to eq entry[:authors]
      expect(pck.version).to eq entry[:version]
      expect(pck.maintainers).to eq entry[:maintainers]
      expect(pck.license).to eq entry[:license]
      expect(pck.publication_date).to eq entry[:publication_date]
    end
    
    it 'updates existing packages' do
      pck = Package.create!(title: 'abc', description: 'blabla')
      allow(parser).to receive(:data).with(['some_link']) { [entry] }

      expect { parser.refresh_repos }.to change { pck.reload.description }.to('abc')
    end
  end
end
