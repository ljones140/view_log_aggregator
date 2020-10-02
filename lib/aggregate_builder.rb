# frozen_string_literal: true

require './lib/page_entry'

class AggregateBuilder
  attr_reader :page_views

  def initialize
    @page_views = {}
  end

  def add_entry(page_name:, visitor_ip:)
    page_entry = @page_views.fetch(page_name) {
      new_entry = PageEntry.new(name: page_name)
      @page_views[page_name] = new_entry
      new_entry
    }
    page_entry.add_view(ip: visitor_ip)
  end
end
