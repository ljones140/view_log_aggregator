# frozen_string_literal: true

require 'spec_helper'
require './lib/log_parser'

RSpec.describe LogParser do
  class TestPrinter
    attr_reader :visits_received, :unique_views_received, :rendered
    def visits(data)
      @visits_received = data
    end

    def unique_views(data)
      @unique_views_received = data
    end

    def render
      @rendered = true
    end
  end

  it 'sends aggregated visits to printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.visits_received).to eq(
      [['/about', 3], ['/contact', 2]],
    )
  end

  it 'sends aggregated unique views to printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.unique_views_received).to eq(
      [['/contact', 2], ['/about', 1]],
    )
  end

  it 'calls render on the printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.rendered).to eq(true)
  end
end
