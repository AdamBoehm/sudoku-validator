class Validator

  def initialize(puzzle_string)
    @puzzle = puzzle_string.gsub(/\D/, '').split('').map(&:to_i)
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    if sub_groups_valid?
      if sub_groups_complete?
        "This sudoku is valid."
      else
        "This sudoku is valid, but incomplete."
      end
    else
      "This sudoku is invalid."
    end
  end

  def rows
    @puzzle.each_slice(9).to_a
  end

  def columns
    rows.transpose
  end

  def grids
    grids = []
      rows.each_slice(3).to_a.each do |sub_group|
        [0..2, 3..5, 6..8].each do |position|
          grids << sub_group.map{ |row| row[position] }.flatten  
        end
      end
    grids
  end

  def sub_groups
    [rows, columns, grids]
  end

  def sub_groups_complete?
    if sub_groups.flatten.include?(0)
      return false
    else
      sub_groups.map(&:count).uniq.min == 9
    end
  end

  def sub_groups_valid?
    if sub_groups_min_max_valid? && sub_groups_uniq?
      return true
    else
      return false
    end
  end

  def sub_groups_uniq?
    sub_groups.each do |sub_group|
      sub_group.each do |group|
        unless (group - [0]).uniq.count == (group - [0]).count
          return false
        end
      end
    end
    return true
  end

  def sub_groups_min_max_valid?
    flat_group = sub_groups.flatten
    if flat_group.max > 9 || (flat_group - [0]).min < 1
      return false
    else
      return true
    end
  end
end
