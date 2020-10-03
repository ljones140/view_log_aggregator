# frozen_string_literal: true

require 'tty-table'

class Printer
  def visits(data)
    TTY::Table.new(['Page name', 'visits'], data)
  end

  def unique_views(data)
    TTY::Table.new(['Page name', 'Unique Views'], data)
  end
end
