# frozen_string_literal: true

require './lib/page_entry'
require './lib/page_view_aggregator'

class LogParser
  def initialize(printer)
    @printer = printer
  end

  def parse_log(file_path)
    aggregator = PageViewAggregator.new
    File.readlines(file_path).each do |line|
      name, ip = line.split
      aggregator.add_entry(page_name: name, visitor_ip: ip)
    end
    aggregator.page_visits.sort_by(&:visits).reverse
              .map { |entry| [entry.name, entry.visits] }
              .then { |results| @printer.print_visits(results) }
  end
end
