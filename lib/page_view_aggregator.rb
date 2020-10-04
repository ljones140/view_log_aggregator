# frozen_string_literal: true

require './lib/page_entry'
require 'ipaddr'

class PageViewAggregator
  attr_reader :invalid_entries
  def initialize
    @page_entries = {}
    @invalid_entries = []
  end

  def visits_data
    @page_entries
      .values
      .sort_by(&:visits).reverse
      .map { |entry| [entry.name, entry.visits] }
  end

  def unique_views_data
    @page_entries
      .values
      .sort_by(&:unique_views).reverse
      .map { |entry| [entry.name, entry.unique_views] }
  end

  def add_entry(page_name:, visitor_ip:)
    begin
      ip = IPAddr.new(visitor_ip)
    rescue IPAddr::InvalidAddressError
      @invalid_entries << [page_name, visitor_ip].join(' ')
      return
    end
    add_visit(page_name, ip)
  end


  private

  def add_visit(name, ip)
    page_entry = @page_entries.fetch(name) {
      new_entry = PageEntry.new(name: name)
      @page_entries[name] = new_entry
      new_entry
    }
    page_entry.add_visit(ip: ip)
  end
end
