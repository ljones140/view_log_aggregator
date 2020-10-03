# frozen_string_literal: true

require 'spec_helper'
require './lib/page_entry'

RSpec.describe PageEntry do
  it 'is created with name' do
    page = described_class.new(name: '/page-name')
    expect(page.name).to eq('/page-name')
  end

  describe 'adding page visits' do
    it 'increments visit count by 1' do
      page = described_class.new(name: '/page-name')
      expect { page.add_visit(ip: IPAddr.new('192.168.0.1')) }
        .to change { page.visits }
        .from(0)
        .to(1)
    end

    describe 'counting unique views' do
      it 'returns a count of each added visit when visits have come from different ip addresses' do
        page = described_class.new(name: '/page-name')
        expect {
          page.add_visit(ip: IPAddr.new('192.168.0.1'))
          page.add_visit(ip: IPAddr.new('192.168.0.2'))
        }.to change { page.unique_views }
          .from(0)
          .to(2)
      end

      it 'does not count duplicate ip addresses when visits have come from the same ip addresses' do
        page = described_class.new(name: '/page-name')
        expect {
          2.times { page.add_visit(ip: IPAddr.new('192.168.0.1')) }
        }.to change { page.unique_views }
          .from(0)
          .to(1)
      end
    end
  end
end
