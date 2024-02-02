# frozen_string_literal: true

module Database
  class Database
    def set(name, value) # rubocop:disable Metrics/AbcSize
      value_was = data[name]
      return false if value_was == value

      current_transaction.change_data(name, value_was, value) if transaction_in_progress?
      data[name] = value

      current_transaction.change_counter(value_was, counter[value_was], -1) if transaction_in_progress? && value_was
      counter[value_was] -= 1 if value_was

      current_transaction.change_counter(value, counter[value], 1) if transaction_in_progress?
      counter[value] += 1

      true
    end

    def get(name)
      data[name]
    end

    def delete(name)
      value_was = data.delete(name)
      return false unless value_was

      current_transaction.change_data(name, value_was, nil) if transaction_in_progress?

      current_transaction.change_counter(value_was, counter[value_was], -1) if transaction_in_progress?
      counter[value_was] -= 1

      true
    end

    def count(value)
      counter[value]
    end

    def begin
      transactions << Transaction.new

      true
    end

    def commit
      return false unless transaction_in_progress?

      transactions.clear
      compact

      true
    end

    def rollback
      return false unless transaction_in_progress?

      data.merge!(current_transaction.data_was)
      counter.merge!(current_transaction.counter_was)
      transactions.pop
      compact

      true
    end

    private

    def data
      @data ||= {}
    end

    def counter
      @counter ||= Hash.new(0)
    end

    def transactions
      @transactions ||= []
    end

    def transaction_in_progress?
      !transactions.empty?
    end

    def current_transaction
      transactions.last
    end

    def compact
      data.compact!
      counter.delete_if { |_, v| v.to_i.zero? }
    end
  end
end
