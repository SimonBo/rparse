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
      puts Package.count
      allow(parser).to receive(:data) { [entry] }

      expect { parser.refresh_repos }.to change { pck.reload.description }.to('abc')
    end
  end
end