# frozen_string_literal: true

require 'spec_helper'
require './lib/page_view_aggregator'

RSpec.describe PageViewAggregator do
  describe 'adding page visits' do
    it 'adds a page entry' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
      expect(aggregator.page_entries['/foo'].name).to eq('/foo')
    end

    it 'adds a new page entries with visit count of 1' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
      expect(aggregator.page_entries['/foo'].visits).to eq(1)
    end

    it 'adds page to invalid entries not page visits when IP is invalid' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: 'not an IP address')
      expect(aggregator.invalid_entries).to eq([{ name: '/foo', ip: 'not an IP address' }])
      expect(aggregator.page_entries).to eq({})
    end

    context 'when adding same page multiple times' do
      it 'does not create a new page entry' do
        aggregator = described_class.new
        aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        expect {
          aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        }.not_to change { aggregator.page_entries }
      end

      it 'does increment the page entries visit count' do
        aggregator = described_class.new
        aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        expect {
          aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        }.to change { aggregator.page_entries['/foo'].visits }
          .from(1)
          .to(2)
      end
    end
  end
end
