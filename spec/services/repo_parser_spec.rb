require 'rails_helper'

RSpec.describe RepoParser do
  let(:entry) { 
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
  }
  let(:parser) { RepoParser.new(package_data: [entry]) } 
  
  describe '#refresh_repos' do 
    it "creates new packages" do
      expect(Package.count).to eq 0
      
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
    
    it "updates existing packages" do
      pck = Package.create!(title: 'abc', description: 'blabla')
      
      expect { parser.refresh_repos }.to change { pck.reload.description }.to('abc')
    end
  end
end