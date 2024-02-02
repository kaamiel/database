# frozen_string_literal: true

require 'English'

module Database
  class CommandInterpreter
    def run
      while (print '> '; gets)
        command = $LAST_READ_LINE.strip
        next if command.empty?

        process(command)
      end

      puts
    end

    private

    def process(command) # rubocop:disable Metrics
      case command
      when /\ASET\s+(\S+)\s+(\S+)\z/i
        name, value = Regexp.last_match.captures
        database.set(name, value)
      when /\AGET\s+(\S+)\z/i
        name, = Regexp.last_match.captures
        puts database.get(name) || 'NULL'
      when /\ADELETE\s+(\S+)\z/i
        name, = Regexp.last_match.captures
        database.delete(name)
      when /\ACOUNT\s+(\S+)\z/i
        value, = Regexp.last_match.captures
        puts database.count(value)
      when /\ABEGIN\z/i
        database.begin
      when /\AROLLBACK\z/i
        puts 'NO TRANSACTION' unless database.rollback
      when /\ACOMMIT\z/i
        puts 'NO TRANSACTION' unless database.commit
      else
        puts "invalid command: #{command.inspect}"
      end
    end

    def database
      @database ||= Database.new
    end
  end
end
