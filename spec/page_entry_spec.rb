# frozen_string_literal: true

require 'spec_helper'
require './lib/page_entry'

RSpec.describe PageEntry do
  it 'is created with name' do
    page = described_class.new(name: '/page-name')
    expect(page.name).to eq('/page-name')
  end

  it 'is created with a view_count of 0' do
    page = described_class.new(name: '/page-name')
    expect(page.view_count).to eq(0)
  end

  describe 'adding page views' do
    it 'increments view_count by 1' do
      page = described_class.new(name: '/page-name')
      expect { page.add_view(ip: IPAddr.new('192.168.0.1')) }
        .to change { page.view_count }
        .from(0)
        .to(1)
    end

    describe '#unique_visitors' do
      it 'returns a count of each added view when views have come from different ip addresses' do
        page = described_class.new(name: '/page-name')
        page.add_view(ip: IPAddr.new('192.168.0.1'))
        page.add_view(ip: IPAddr.new('192.168.0.2'))
        expect(page.unique_views).to eq(2)
      end

      it 'does not count duplicate ip addresses when views have come from the same ip addresses' do
        page = described_class.new(name: '/page-name')
        page.add_view(ip: IPAddr.new('192.168.0.1'))
        page.add_view(ip: IPAddr.new('192.168.0.1'))
        expect(page.unique_views).to eq(1)
      end
    end
  end
end
