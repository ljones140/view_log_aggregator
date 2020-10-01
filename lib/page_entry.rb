# frozen_string_literal: true

class PageEntry
  attr_reader :name, :view_count

  def initialize(name:)
    @name = name
    @view_count = 0
  end

  def add_view
    @view_count += 1
  end
end
