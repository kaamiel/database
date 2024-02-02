# frozen_string_literal: true

require 'stringio'

RSpec.describe Database::CommandInterpreter do
  subject(:command_interpreter) { described_class.new }

  before { $stdin = StringIO.new(stdin) }
  after { $stdin = STDIN }

  shared_examples_for 'run' do
    it 'reads commands and outputs results' do
      expect do
        command_interpreter.run
      end.to output(stdout).to_stdout
    end
  end

  describe 'example' do
    let(:stdin) do
      <<~TEXT
        SET a 10
        GET a
        DELETE a
        GET a
        SET a 10
        SET b 10
        COUNT 10
        COUNT 20
        DELETE a
        COUNT 10
        SET b 30
        COUNT 10
      TEXT
    end
    let(:stdout) do
      <<~TEXT
        > > 10
        > > NULL
        > > > 2
        > 0
        > > 1
        > > 0
        > 
      TEXT
    end

    include_examples 'run'
  end

  describe 'example 1' do
    let(:stdin) do
      <<~TEXT
        BEGIN
        SET a 10
        GET a
        BEGIN
        SET a 20
        GET a
        ROLLBACK
        GET a
        ROLLBACK
        GET a
      TEXT
    end
    let(:stdout) do
      <<~TEXT
        > > > 10
        > > > 20
        > > 10
        > > NULL
        > 
      TEXT
    end

    include_examples 'run'
  end

  describe 'example 2' do
    let(:stdin) do
      <<~TEXT
        BEGIN
        SET a 30
        BEGIN
        SET a 40
        COMMIT
        GET a
        ROLLBACK
      TEXT
    end
    let(:stdout) do
      <<~TEXT
        > > > > > > 40
        > NO TRANSACTION
        > 
      TEXT
    end

    include_examples 'run'
  end

  describe 'example 3' do
    let(:stdin) do
      <<~TEXT
        SET a 50
        BEGIN
        GET a
        SET a 60
        BEGIN
        DELETE a
        GET a
        ROLLBACK
        GET a
        COMMIT
        GET a
      TEXT
    end
    let(:stdout) do
      <<~TEXT
        > > > 50
        > > > > NULL
        > > 60
        > > 60
        > 
      TEXT
    end

    include_examples 'run'
  end

  describe 'example 4' do
    let(:stdin) do
      <<~TEXT
        SET a 10
        BEGIN
        COUNT 10
        BEGIN
        DELETE a
        COUNT 10
        ROLLBACK
        COUNT 10
      TEXT
    end
    let(:stdout) do
      <<~TEXT
        > > > 1
        > > > 0
        > > 1
        > 
      TEXT
    end

    include_examples 'run'
  end
end
