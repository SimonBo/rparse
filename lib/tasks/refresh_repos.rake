# frozen_string_literal: true

task refresh_repos: :environment do |_t|
  RepoParser.new.refresh_repos
end
