# frozen_string_literal: true

require 'spec_helper'
require './lib/printer'

require 'tty-table'

RSpec.describe Printer do
  it 'creates visits TTY Table' do
    printer = described_class.new
    expect(TTY::Table).to receive(:new).with(
      ['Page name', 'visits'],
      [['/foo', 1], ['/bar', 1]],
    )
    printer.visits([['/foo', 1], ['/bar', 1]])
  end

  it 'creates unique views TTY Table' do
    printer = described_class.new
    expect(TTY::Table).to receive(:new).with(
      ['Page name', 'Unique Views'],
      [['/foo', 1], ['/bar', 1]],
    )
    printer.unique_views([['/foo', 1], ['/bar', 1]])
  end
end
