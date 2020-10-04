# frozen_string_literal: true

require 'spec_helper'
require './lib/printer'

require 'tty-table'

RSpec.describe Printer do
  before do
    allow($stdout).to receive(:puts)
  end

  it 'creates visits TTY Table' do
    printer = described_class.new
    expect(TTY::Table).to receive(:new).with(
      ['Page name', 'visits'],
      [['/foo', 1], ['/bar', 1]],
    ).and_call_original
    printer.print_visits([['/foo', 1], ['/bar', 1]])
  end

  it 'creates unique views TTY Table' do
    printer = described_class.new
    expect(TTY::Table).to receive(:new).with(
      ['Page name', 'Unique Views'],
      [['/foo', 1], ['/bar', 1]],
    ).and_call_original
    printer.print_unique_views([['/foo', 1], ['/bar', 1]])
  end

  it 'prints invalid entries' do
    expect {
      described_class.new.print_invalid_entries(
        ['/foo not_an_ip', '/bar not_an_ip'],
      )
    }.to output(
      "Invalid Entries\n/foo not_an_ip\n/bar not_an_ip\n",
    ).to_stdout
  end
end
