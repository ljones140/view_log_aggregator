# frozen_string_literal: true

require 'spec_helper'
require './lib/page_view_aggregator'

RSpec.describe PageViewAggregator do
  describe 'adding page views' do
    it 'adds a page entry' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
      expect(aggregator.page_views['/foo'].name).to eq('/foo')
    end

    it 'adds new page entries with view count of 1' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
      expect(aggregator.page_views['/foo'].views).to eq(1)
    end

    it 'adds page to invalid entries not page views when IP is invalid' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: 'not an IP address')
      expect(aggregator.invalid_entries).to eq([{ name: '/foo', ip: 'not an IP address' }])
      expect(aggregator.page_views).to eq({})
    end

    context 'when adding same page multiple times' do
      it 'does not create a new page entry' do
        aggregator = described_class.new
        aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        expect {
          aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        }.not_to change { aggregator.page_views }
      end

      it 'does increment the page entries view count' do
        aggregator = described_class.new
        aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        expect {
          aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        }.to change { aggregator.page_views['/foo'].views }
          .from(1)
          .to(2)
      end
    end
  end
end
