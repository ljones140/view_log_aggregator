# frozen_string_literal: true

require './lib/page_entry'
require 'ipaddr'

class PageViewAggregator
  attr_reader :page_views, :invalid_entries

  def initialize
    @page_views = {}
    @invalid_entries = []
  end

  def add_entry(page_name:, visitor_ip:)
    begin
      ip = IPAddr.new(visitor_ip)
    rescue IPAddr::InvalidAddressError
      @invalid_entries << { name: page_name, ip: visitor_ip }
      return
    end
    add_to_page_views(page_name, ip)
  end

  private

  def add_to_page_views(name, ip)
    page_entry = @page_views.fetch(name) {
      new_entry = PageEntry.new(name: name)
      @page_views[name] = new_entry
      new_entry
    }
    page_entry.add_view(ip: ip)
  end
end
