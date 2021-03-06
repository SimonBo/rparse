# frozen_string_literal: true

require 'test_helper'

class RepoParserTest < ActiveSupport::TestCase
  def parser
    RepoParser.new
  end

  def entry
    "Package: A3\nType: Package\nTitle: Accurate, Adaptable, and Accessible Error Metrics for Predictive\n        Models\nVersion: 1.0.0\nDate: 2015-08-15\nAuthor: Scott Fortmann-Roe\nMaintainer: Scott Fortmann-Roe <scottfr@berkeley.edu>\nDescription: Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.\nLicense: GPL (>= 2)\nDepends: R (>= 2.15.0), xtable, pbapply\nSuggests: randomForest, e1071\nNeedsCompilation: no\nPackaged: 2015-08-16 14:17:33 UTC; scott\nRepository: CRAN\nDate/Publication: 2015-08-16 23:05:52\n"
  end

  test 'the truth' do
    result = parser.parse_entry(entry)
    authors = result[:authors]
    puts authors
    assert authors == 'Scott Fortmann-Roe'
  end
end
