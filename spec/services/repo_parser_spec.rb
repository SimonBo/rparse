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
      expect { parser.refresh_repos }.to change { Package.count }.by(1)
    end
    
    it "updates existing packages", :focus do
      pck = Package.create!(title: 'abc', description: 'blabla')
      
      expect { parser.refresh_repos }.to change { pck.reload.description }.to('abc')
    end
  end
end