# frozen_string_literal: true

require 'ipaddr'

class PageEntry
  attr_reader :name

  def initialize(name:)
    @name = name
    @visitor_ips = []
  end

  def add_view(ip:)
    @visitor_ips << ip
  end

  def views
    @visitor_ips.count
  end

  def unique_views
    @visitor_ips.uniq.count
  end
end
