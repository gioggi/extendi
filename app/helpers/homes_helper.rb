module HomesHelper
  require 'csv'
  def validate_csv_file(file)
    return false unless file.content_type == 'text/csv'
    return false unless file.original_filename.split('.').last == 'csv'

    grid = CSV.open(file.path).each.to_a
    return false unless validate_grid(grid)

    grid
  end

  def validate_grid(grid)
    return false unless grid.length > 0

    grid.each do |row|
      return false unless row.length == grid.length && (row - %w[. *]).empty?
    end
    true
  end

  def game_of_life(grid)
    new_grid = []
    grid.each_with_index do |row, row_index|
      new_grid[row_index] = []
      row.each_with_index do |cell, cell_index|
        live_neighbours = get_live_neighbours([row_index, cell_index], grid)
        new_grid[row_index][cell_index] = check_rules(cell, live_neighbours)
      end
    end
    new_grid
  end

  # cell = [0,0]
  # grid = [
  # %w[* . .],
  # %w[* . *],
  # %w[. * .]
  # ]
  def get_live_neighbours(cell_coordinates, grid)
    live_neighbours = 0

    # this block circular matrix, change with xvals = [-1, 0, 1] and yvals = [-1, 0, 1] IF you don't want to use it
    xvals = get_xvals(cell_coordinates, grid)
    yvals = get_yvals(cell_coordinates, grid)

    yvals.each do |y|
      xvals.each do |x|
        next if x == 0 && y == 0

        next unless grid[cell_coordinates[0] + y][cell_coordinates[1] + x] == '*'

        live_neighbours += 1
      end
    end
    live_neighbours
  end

  # 1.Any live cell with fewer than two live neighbours dies.
  # 2.Any live cell with two or three live neighbours lives on to the next generation.
  # 3.Any live cell with more than three live neighbours dies.
  # 4.Any dead cell with exactly three live neighbours becomes a live cell.
  def check_rules(cell, live_neighbours)
    return '.' if cell == '*' && live_neighbours < 2
    return '*' if cell == '*' && [2, 3].include?(live_neighbours)
    return '.' if cell == '*' && live_neighbours > 3
    return '*' if cell == '.' && live_neighbours == 3

    cell
  end

  private

  # this block circular matrix, change with yvals = [-1, 0, 1]  IF you don't want to use it
  def get_yvals(cell_coordinates, grid)
    yvals = []
    yvals.push(-1) if cell_coordinates[0] > 0
    yvals.push 0
    yvals.push(+1) if cell_coordinates[0] < grid.length - 1
    yvals
  end

  # this block circular matrix, change with xvals = [-1, 0, 1]  IF you don't want to use it
  def get_xvals(cell_coordinates, grid)
    xvals = []
    xvals.push(-1) if cell_coordinates[1] > 0
    xvals.push 0
    xvals.push(+1) if cell_coordinates[1] < grid[1].length - 1
    xvals
  end
end
