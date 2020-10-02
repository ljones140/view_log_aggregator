# frozen_string_literal: true

require 'spec_helper'
require './lib/aggregate_builder'

RSpec.describe AggregateBuilder do
  describe 'adding page views' do
    it 'adds a page entry' do
      aggregate_builder = described_class.new
      aggregate_builder.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
      expect(aggregate_builder.page_views['/foo'].name).to eq('/foo')
    end

    it 'adds new page entries with view count of 1' do
      aggregate_builder = described_class.new
      aggregate_builder.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
      expect(aggregate_builder.page_views['/foo'].views).to eq(1)
    end

    it 'adds page to invalid address when IP is invalid' do
      aggregate_builder = described_class.new
      aggregate_builder.add_entry(page_name: '/foo', visitor_ip: 'not an IP address')
      expect(aggregate_builder.invalid_entries).to eq([{ name: '/foo', ip: 'not an IP address' }])
      expect(aggregate_builder.page_views).to eq({})
    end

    context 'when adding same page multiple times' do
      it 'does not create a new page entry' do
        aggregate_builder = described_class.new
        aggregate_builder.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        expect {
          aggregate_builder.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        }.not_to change { aggregate_builder.page_views }
      end

      it 'does increment the page entries view count' do
        aggregate_builder = described_class.new
        aggregate_builder.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        expect {
          aggregate_builder.add_entry(page_name: '/foo', visitor_ip: '192.168.0.1')
        }.to change { aggregate_builder.page_views['/foo'].views }
          .from(1)
          .to(2)
      end
    end
  end
end
