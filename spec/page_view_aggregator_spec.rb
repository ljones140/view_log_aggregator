# frozen_string_literal: true

require 'spec_helper'
require './lib/page_view_aggregator'

RSpec.describe PageViewAggregator do
  describe 'adding entries with valid ip addresses' do
    describe '#visits_data' do
      it 'returns page visits data ordered by number of visits' do
        aggregator = described_class.new
        aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        aggregator.add_entry(page_name: '/bar', visitor_ip: '192.168.0.1')
        expect(aggregator.visits_data).to eq(
          [['/foo', 2], ['/bar', 1]],
        )
      end

      describe '#unique_views_data' do
        it 'returns unique views data ordered by number of unique ip address visits' do
          aggregator = described_class.new
          aggregator.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
          aggregator.add_entry(page_name: '/bar', visitor_ip: '192.168.0.2')
          aggregator.add_entry(page_name: '/bar', visitor_ip: '192.168.0.1')
          expect(aggregator.unique_views_data).to eq(
            [['/bar', 2], ['/foo', 1]],
          )
        end
      end
    end
  end

  describe 'adding entries with invalid ip addresses' do
    it 'does not return the entry as visits data' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: 'not an IP address')
      expect(aggregator.visits_data).to eq([])
    end

    it 'does not return the entry as unique views data' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: 'not an IP address')
      expect(aggregator.unique_views_data).to eq([])
    end

    it 'adds the entry to invalid entries' do
      aggregator = described_class.new
      aggregator.add_entry(page_name: '/foo', visitor_ip: 'not an IP address')
      expect(aggregator.invalid_entries).to eq(['/foo not an IP address'])
    end
  end
end
