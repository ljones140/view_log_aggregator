# frozen_string_literal: true

require 'spec_helper'
require './lib/log_parser'

RSpec.describe LogParser do
  class TestPrinter
    attr_reader :visits_received
    def print_visits(data)
      @visits_received = data
    end
  end

  it 'sends aggregated visits to printer' do
    printer = TestPrinter.new
    parser = described_class.new(printer)
    parser.parse_log('spec/support/example.log')
    expect(printer.visits_received).to eq(
      [['/about', 2], ['/contact', 1]],
    )
  end
end
