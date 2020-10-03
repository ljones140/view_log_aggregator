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
    print_load_page_visits(@aggregator.page_visits)
    print_load_unique_views(@aggregator.page_visits)
    @printer.render
  end

  private

  def print_load_page_visits(visits)
    visits.sort_by(&:visits).reverse
          .map { |entry| [entry.name, entry.visits] }
          .then { |results| @printer.visits(results) }
  end

  def print_load_unique_views(visits)
    visits.sort_by(&:unique_views).reverse
          .map { |entry| [entry.name, entry.unique_views] }
          .then { |results| @printer.unique_views(results) }
  end
end
