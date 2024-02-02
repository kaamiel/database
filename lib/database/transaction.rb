# frozen_string_literal: true

module Database
  class Transaction
    Change = Struct.new(:from, :to)

    def change_data(name, from, to)
      change(data_changes, name, from, to)
    end

    def change_counter(value, from, difference)
      from ||= 0
      to = from + difference

      change(counter_changes, value, from, to)
    end

    def data_was
      data_changes.transform_values(&:from)
    end

    def counter_was
      counter_changes.transform_values(&:from)
    end

    private

    def data_changes
      @data_changes ||= {}
    end

    def counter_changes
      @counter_changes ||= {}
    end

    def change(changes, key, from, to)
      saved_change = changes[key]

      if saved_change
        if saved_change.from == to
          changes.delete(key) # no need to remember this change
        else
          saved_change.to = to
        end
      else
        changes[key] = Change.new(from:, to:)
      end
    end
  end
end
