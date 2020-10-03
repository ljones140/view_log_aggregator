# frozen_string_literal: true

require 'ipaddr'

class PageEntry
  attr_reader :name

  def initialize(name:)
    @name = name
    @visitor_ips = []
    @visit_count = 0
    @unique_view_count = 0
  end

  def add_visit(ip:)
    @visit_count += 1
    @unique_view_count += 1 unless @visitor_ips.include?(ip)
    @visitor_ips << ip
  end

  def visits
    @visit_count
  end

  def unique_views
    @unique_view_count
  end
end
