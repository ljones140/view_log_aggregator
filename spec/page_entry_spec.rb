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
end
