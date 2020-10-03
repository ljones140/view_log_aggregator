# frozen_string_literal: true

require './lib/page_entry'
require './lib/page_view_aggregator'

class LogParser
  def initialize(printer)
    @printer = printer
    @aggregator = PageViewAggregator.new
  end

  def parse_log(file_path)
    File.readlines(file_path).each do |line|
      name, ip = line.split
      @aggregator.add_entry(page_name: name, visitor_ip: ip)
    end
    print_page_visits(@aggregator.page_visits)
    print_page_unique_views(@aggregator.page_visits)
  end

  private

  def print_page_visits(visits)
    visits.sort_by(&:visits).reverse
          .map { |entry| [entry.name, entry.visits] }
          .then { |results| @printer.print_visits(results) }
  end

  def print_page_unique_views(visits)
    visits.sort_by(&:unique_views).reverse
          .map { |entry| [entry.name, entry.unique_views] }
          .then { |results| @printer.print_unique_views(results) }
  end
end
