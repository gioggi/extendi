require 'rails_helper'

RSpec.describe HomesHelper, type: :helper do
  describe 'Homes helper' do
    describe 'should return correct neighbours' do
      before(:all) do
        @grid = [
          %w[* . .],
          %w[* . *],
          %w[. * .]
        ]
      end
      it '[0,0] should return 1' do
        expect(get_live_neighbours([0, 0], @grid)).to eq(1)
      end
      it '[0,1] should return 2' do
        expect(get_live_neighbours([0, 1], @grid)).to eq(3)
      end
      it '[1,1] should return 4' do
        expect(get_live_neighbours([1, 1], @grid)).to eq(4)
      end
      it '[1,2] should return 1' do
        expect(get_live_neighbours([1, 2], @grid)).to eq(1)
      end
      it '[0,2] should return 1' do
        expect(get_live_neighbours([0, 2], @grid)).to eq(1)
      end
    end

    describe 'should return correct rules' do
      it 'should return . if cell is * and live neighbours are < 2' do
        expect(check_rules('*', 1)).to eq('.')
      end
      it 'should return * if cell is * and live neighbours are 2' do
        expect(check_rules('*', 2)).to eq('*')
      end
      it 'should return * if cell is * and live neighbours are 3' do
        expect(check_rules('*', 3)).to eq('*')
      end
      it 'should return . if cell is * and live neighbours are > 3' do
        expect(check_rules('*', 4)).to eq('.')
      end
      it 'should return * if cell is . and live neighbours are 3' do
        expect(check_rules('.', 3)).to eq('*')
      end
      it 'should return . if cell is . and live neighbours are 2' do
        expect(check_rules('.', 2)).to eq('.')
      end
    end
    describe 'should return correct game of life' do
      before(:all) do
        @grid = [
          %w[* . .],
          %w[* . *],
          %w[. * .]
        ]
      end
      it 'should return correct grid with first generation' do
        expect(game_of_life(@grid)).to eq([
                                            %w[. * .],
                                            %w[* . .],
                                            %w[. * .]
                                          ])
      end

      it 'should return correct grid with second generation' do
        first_round = game_of_life(@grid)
        expect(game_of_life(first_round)).to eq([
                                                  %w[. . .],
                                                  %w[* * .],
                                                  %w[. . .]
                                                ])
      end
    end

    # validate validate_csv_file
    describe 'should is correct csv file' do
      csv_tempfile = Tempfile.new(['test_generation', '.csv'])
      CSV.open(csv_tempfile, 'w', col_sep: ',', headers: false) do |csv|
        csv << %w[. *]
        csv << %w[. .]
      end
      it 'should return true if file is csv and valid' do
        file = fixture_file_upload(csv_tempfile.path, 'text/csv')
        expect(validate_csv_file(file)).to be_truthy
      end
      csv_tempfile_two = Tempfile.new(['test_generation_two', '.csv'])
      CSV.open(csv_tempfile_two, 'wb', col_sep: ';', headers: true) do |csv|
        csv << %w[. *]
        csv << %w[. *]
        csv << %w[. *]
        csv << %w[. *]
      end
      it 'should return fakse if file is csv and not ' do
        file = fixture_file_upload(csv_tempfile_two.path, 'text/csv')
        expect(validate_csv_file(file)).to be_falsey
      end
      csv_tempfile_three = Tempfile.new(['csv_tempfile_three', '.csv'])
      CSV.open(csv_tempfile_three, 'wb', col_sep: ';', headers: true) do |csv|
        csv << %w[. a]
        csv << %w[. *]
      end
      it 'should return false if file is csv not valid' do
        file = fixture_file_upload(csv_tempfile_three.path, 'text/csv')
        expect(validate_csv_file(file)).to be_falsey
      end
      txt_tempfile = Tempfile.new(['test_generation', '.txt'])
      it 'should return false if file is not csv' do
        file = fixture_file_upload(txt_tempfile.path, 'text/csv')
        expect(validate_csv_file(file)).to be_falsey
      end
    end

    # validate validate_grid
    describe 'should return correct grid' do
      it 'should return true if grid is valid' do
        grid = [
          %w[* . .],
          %w[* . *],
          %w[. * .]
        ]
        expect(validate_grid(grid)).to be_truthy
      end
      it 'should return false if grid is not valid' do
        grid = [
          %w[* . .],
          %w[* . *],
          %w[. * .],
          %w[. * .]
        ]
        expect(validate_grid(grid)).to be_falsey
      end
    end
  end
end
