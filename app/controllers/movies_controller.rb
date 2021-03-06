class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    if params[:refresh] != nil
      session[:ratings] = Hash[@all_ratings.collect { |item| [item, "1"] } ]
    end
    if params[:sort] == nil && params[:ratings] == nil
      params[:sort] = session[:sort]
      params[:ratings] = session[:ratings]
    end
    if params[:sort] == "title"
      session[:sort] = params[:sort]
      ratings_list = session[:ratings].keys
      @movies = Movie.with_ratings(ratings_list).sort_by &:title
    elsif params[:sort] == "release_date"
      session[:sort] = params[:sort]
      ratings_list = session[:ratings].keys
      @movies = Movie.with_ratings(ratings_list).sort_by &:release_date
    elsif params[:ratings] != nil
      session[:ratings] = params[:ratings]
      ratings_list = session[:ratings].keys
      @movies = Movie.with_ratings(ratings_list)
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
end
