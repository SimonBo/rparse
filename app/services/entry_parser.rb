# frozen_string_literal: true

class EntryParser
  def parse(entry)
    {
      name: entry[/(?<=Package:)(.*)(?=Type:)/m]&.strip,
      description: entry[/(?<=Description:)(.*)(?=License:)/m]&.strip,
      title: entry[/(?<=Title:)(.*)(?=Version:)/m]&.strip,
      authors: entry[/(?<=Author: )(.*)(?=Maintainer:)/m]&.strip,
      version: entry[/(?<=Version:)(.*)(?=Date:)/m]&.strip,
      maintainers: entry[/(?<=Maintainer:)(.*)(?=Description:)/m]&.strip,
      license: entry[/(?<=License:)(.*)(?=Depends:)/m]&.strip,
      publication_date: entry[/(?<=Publication:)(.*)/m]&.strip&.to_datetime
    }
  end
 end
