# frozen_string_literal: true

require 'spec_helper'
require './lib/log_parser'

RSpec.describe LogParser do
  class TestPrinter
    attr_reader :visits_received, :unique_views_received, :invalide_entries_received
    def print_visits(data)
      @visits_received = data
    end

    def print_unique_views(data)
      @unique_views_received = data
    end

    def print_invalid_entries(data)
      @invalide_entries_received = data
    end
  end

  it 'sends aggregated visits to printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer: printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.visits_received).to eq(
      [['/about', 3], ['/contact', 2]],
    )
  end

  it 'sends aggregated unique views to printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer: printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.unique_views_received).to eq(
      [['/contact', 2], ['/about', 1]],
    )
  end

  it 'sends invalid entries to printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer: printer)
    parser.parse_log('spec/support/example_with_invalid_ip.log')
    expect(printer.invalide_entries_received).to eq(
      ['/broken not_an_ip_address'],
    )
  end

  it 'does not print invalid entries when there is none' do
    printer = TestPrinter.new
    parser = described_class.new(printer: printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.invalide_entries_received).to be_nil
  end
end
