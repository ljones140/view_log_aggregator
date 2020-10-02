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
  end
end
