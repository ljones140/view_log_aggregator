# frozen_string_literal: true

require './lib/page_entry'
require 'ipaddr'

class AggregateBuilder
  attr_reader :page_views

  def initialize
    @page_views = {}
  end

  def add_entry(page_name:, visitor_ip:)
    page_entry = PageEntry.new(name: page_name)
    @page_views[page_name] = page_entry
    page_entry.add_view(ip: visitor_ip)
  end
end
