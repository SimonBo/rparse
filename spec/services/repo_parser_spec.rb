require 'rails_helper'

RSpec.describe RepoParser do
  let(:parser) { RepoParser.new } 
  let(:entry) { {
    description: 'abc',
    title: 'abc',
    authors: 'abc',
    version: 'abc',
    maintainers: 'abc',
    license: 'abc',
    publication_date: DateTime.new
  } 
}

  describe '#refresh_repos' do 
    it "creates new packages" do
      allow(parser).to receive(:data) { [entry] }
      expect { parser.refresh_repos }.to change { Package.count }.by(1)
    end

    it "updates existing packages", :focus do
      pck = Package.create!(title: 'abc', description: 'blabla')
      allow(parser).to receive(:data) { [entry] }

      expect { parser.refresh_repos }.to change { pck.reload.description }.to('abc')
    end
  end

  describe '#data' do 
    it "fetches data from links" do
      VCR.use_cassette 'packages/A3' do
        result = parser.data(links: ['A3_1.0.0.tar.gz'])
        expect(result.size).to eq 1
        expect(result.first.is_a?(Hash)).to eq true
        expect(result.first[:authors]).to eq "Scott Fortmann-Roe"
     end
    end
  end
end