# frozen_string_literal: true

RSpec.describe Database do
  it 'has a version number' do
    expect(Database::VERSION).not_to be_nil
  end
end
