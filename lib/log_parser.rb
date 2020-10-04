# frozen_string_literal: true

require './lib/page_entry'
require './lib/page_view_aggregator'
require './lib/printer'

class LogParser
  def initialize(printer: Printer.new)
    @printer = printer
    @aggregator = PageViewAggregator.new
  end

  def parse_log(file_path)
    File.readlines(file_path).each do |line|
      name, ip = line.split
      @aggregator.add_entry(page_name: name, visitor_ip: ip)
    end
    @printer.print_visits(@aggregator.visits_data)
    @printer.print_unique_views(@aggregator.unique_views_data)
    @printer.print_invalid_entries(@aggregator.invalid_entries) if @aggregator.invalid_entries.any?
  end
end
