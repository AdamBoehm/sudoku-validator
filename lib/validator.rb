class Validator

  def initialize(puzzle_string)
    set_puzzle(puzzle_string)
    validate_puzzle_format
    set_sub_groups
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    validate_and_return_message
  end

  def validate_and_return_message
    sub_groups_valid? ? valid_messages : invalid_messages
  end

  def valid_messages
    if sub_groups_complete?
      "This sudoku is valid."
    else
      "This sudoku is valid, but incomplete."
    end
  end

  def invalid_messages
    "This sudoku is invalid."
  end

  def rows
    @puzzle.each_slice(9).to_a
  end

  def columns
    rows.transpose
  end

  def grids
    grids = []
      rows.each_slice(3).to_a.each do |grid|
        [0..2, 3..5, 6..8].each do |position|
          grids << grid.map{ |row| row[position] }.flatten  
        end
      end
    grids
  end

  def sub_groups_complete?
    !@puzzle.include?(0) && @puzzle.count == 81
  end

  def sub_groups_valid?
    sub_groups_min_max_valid? && sub_groups_uniq? 
  end

  # each group in a sub_group must contain unique integers, with exception of 0 
  def sub_groups_uniq?
    @sub_groups.each do |group|
      if (group - [0]).uniq.count != (group - [0]).count
        return false
      end
    end
    return true
  end

  # puzzle must contain only integers between 1..9
  def sub_groups_min_max_valid?
    !(@puzzle.max > 9) && !((@puzzle - [0]).min < 1)
  end

  private
  
  # A subgroup is an array of each number group within rows, columns, and grids
  def set_sub_groups
    @sub_groups = [rows, columns, grids].reduce(:concat)
  end

  def set_puzzle(puzzle_string)
    @puzzle = puzzle_string.gsub(/\D/, '').split('').map(&:to_i)
  end

  def validate_puzzle_format
    unless @puzzle.count == 81
      "This puzzle format is invalid."
      exit(false)
    end
  end

end
