# frozen_string_literal: true

require 'tty-table'

class Printer
  def print_visits(data)
    puts TTY::Table.new(['Page name', 'visits'], data).render(:ascii)
  end

  def print_unique_views(data)
    puts TTY::Table.new(['Page name', 'Unique Views'], data).render(:ascii)
  end

  def print_invalid_entries(data)
    puts 'Invalid Entries'
    puts data
  end
end
