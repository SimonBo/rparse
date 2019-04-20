require 'rails_helper'

RSpec.describe EntryParser do 
  let(:entry) { "Package: A3\nType: Package\nTitle: Accurate, Adaptable, and Accessible Error Metrics for Predictive Models\nVersion: 1.0.0\nDate: 2015-08-15\nAuthor: Scott Fortmann-Roe\nMaintainer: Scott Fortmann-Roe <scottfr@berkeley.edu>\nDescription: Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.\nLicense: GPL (>= 2)\nDepends: R (>= 2.15.0), xtable, pbapply\nSuggests: randomForest, e1071\nNeedsCompilation: no\nPackaged: 2015-08-16 14:17:33 UTC; scott\nRepository: CRAN\nDate/Publication: 2015-08-16 23:05:52\n" } 
  
  describe '#parse' do 
    it "parses entry to a hash" do
      result = EntryParser.new(entry: entry).parse
      expect(result).to satisfy do |r|
        r[:authors] == 'Scott Fortmann-Roe'
        r[:title] == 'Accurate, Adaptable, and Accessible Error Metrics for Predictive Models'
        r[:description] == 'Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.'
        r[:maintainers] == 'Scott Fortmann-Roe <scottfr@berkeley.edu>'
        r[:version] == '1.0.0'
        r[:license] == 'GPL (>= 2)'
        r[:publication_date] == '2015-08-16 23:05:52'.to_datetime
      end
    end
  end
end