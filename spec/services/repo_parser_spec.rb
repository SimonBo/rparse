require 'rails_helper'

RSpec.describe RepoParser do
  let(:parser) { RepoParser.new } 
  let(:entry) { {
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
        allow(parser).to receive(:package_names) { ['A3'] }
        result = parser.data(links: ['A3_1.0.0.tar.gz'])
        expect(result.size).to eq 1
        expect(result.first).to be_instance_of Hash
        expect(result.first[:authors]).to eq "Scott Fortmann-Roe"
     end
    end
  end

  describe "#get_links" do
    it "fetches links to repos" do
      VCR.use_cassette 'package_links' do
        result = parser.get_links
        expect(result.find { |l| l.include?('.tar.gz') }).to be_present
      end
    end
  end

  describe "#package_names" do
    it "gets package names from site" do
      VCR.use_cassette 'package_names' do
        result = parser.package_names
        expect(result).to be_instance_of Array
        expect(result).to include 'A3'
      end
    end
  end
end