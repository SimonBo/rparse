# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'refresh repos rake task' do
  it 'calls task' do
    expect(RepoParser).to receive_message_chain(:new, :refresh_repos)

    Rails.application.load_tasks
    Rake::Task['refresh_repos'].invoke
  end
end
