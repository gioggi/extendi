class HomesController < ApplicationController
  include HomesHelper
  def index
    @grid = session[:grid] || []
  end

  def load_generation
    @grid = validate_csv_file(home_params[:file])
    session[:grid] = @grid || []
    respond_to do |format|
      if @grid
        format.html { redirect_to root_path, notice: 'Generation loaded' }
      else
        format.html { redirect_to root_path, alert: 'Generation not loaded, csv not valid' }
      end
    end
  end

  def next_generation
    @grid = validate_grid(session[:grid]) ? game_of_life(session[:grid]) : false
    session[:grid] = @grid || []
    respond_to do |format|
      if @grid
        format.html { redirect_to root_path, notice: 'New Generation' }
      else
        format.html { redirect_to root_path, notice: 'New Generation' }
      end
    end
  end

  def reset
    session[:grid] = []
  end

  def home_params
    params.require(:home).permit(:file)
  end
end
