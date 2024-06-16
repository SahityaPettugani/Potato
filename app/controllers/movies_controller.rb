class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def index
  #   @movies = Movie.all
  # end
  def index
    @all_ratings = Movie.all_ratings

    if params[:ratings]
      @ratings_to_show_hash = params[:ratings]
    elsif session[:ratings]
      @ratings_to_show_hash = session[:ratings]
    else
      @ratings_to_show_hash = Hash[@all_ratings.map { |rating| [rating, "1"] }]
    end

    # @ratings_to_show_hash = params[:ratings] || session[:ratings] || {}
    @ratings_to_show = @ratings_to_show_hash.keys

    @ratings_to_show_hash = Hash[@ratings_to_show.map { |rating| [rating, "1"] }]

    session[:ratings] = @ratings_to_show_hash unless @ratings_to_show_hash.empty?
    @sort_column = params[:sort] || session[:sort]
    session[:sort] = @sort_column
    @movies = if @ratings_to_show.empty?
                Movie.all
              else
                Movie.with_ratings(@ratings_to_show)
              end

    if @sort_column
      @movies = @movies.order(@sort_column)
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
