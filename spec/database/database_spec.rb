# frozen_string_literal: true

RSpec.describe Database::Database do
  subject(:database) { described_class.new }

  describe 'set' do
    it 'assigns a value to a variable' do
      database.set(:a, 10)

      expect(database.get(:a)).to eq(10)
    end

    it 'increments count of the assigned value' do
      expect { database.set(:a, 10) }.to change { database.count(10) }.by(1)
    end

    it 'decrements count of the previous variable value' do
      database.set(:a, 10)

      expect { database.set(:a, 20) }.to change { database.count(10) }.by(-1)
    end
  end

  describe 'get' do
    it 'returns nil if the variable has not been assigned' do
      expect(database.get(:a)).to be_nil
    end

    it 'returns value assigned to a variable' do
      database.set(:a, 10)

      expect(database.get(:a)).to eq(10)
    end
  end

  describe 'delete' do
    before { database.set(:a, 10) }

    it 'clears the variable' do
      expect { database.delete(:a) }.to change { database.get(:a) }.from(10)
                                                                   .to(nil)
    end

    it 'decrements count of the previous variable value' do
      expect { database.delete(:a) }.to change { database.count(10) }.by(-1)
    end
  end

  describe 'count' do
    it 'returns count of the assigned value' do
      database.set(:a, 10)
      expect(database.count(10)).to eq(1)

      database.set(:b, 10)
      expect(database.count(10)).to eq(2)

      database.set(:a, 10)
      expect(database.count(10)).to eq(2)
    end
  end

  describe 'commit' do
    it 'returns false if there are no transactions in progress' do
      expect(database.commit).to be false
    end
  end

  describe 'rollback' do
    it 'returns false if there are no transactions in progress' do
      expect(database.rollback).to be false
    end
  end
end
