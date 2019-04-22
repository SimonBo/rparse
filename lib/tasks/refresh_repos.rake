task refresh_repos: :environment do |t|
  RepoParser.new.refresh_repos
end
