class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    need_redirect = false
    @all_ratings = Movie.get_all_ratings
    ratings = params[:ratings] || session[:ratings] || {}
    if ratings != {}
      @ratings = ratings
    else
      @ratings = Hash.new
      @all_ratings.each {|r| @ratings[r] = 1}
    end
    if params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      need_redirect = true
    end
    
    sort_by = params[:sort_by] || session[:sort_by]
    if params[:sort_by]
      session[:sort_by] = sort_by
    elsif session[:sort_by]
      need_redirect = true
    end

    if need_redirect
      redirect_to :sort_by => sort_by, :ratings => @ratings
    end

    if sort_by == "title" 
      @movies = Movie.where(rating: @ratings.keys).order("title ASC")
      @title_class = "hilite"
    elsif sort_by == "release_date"
      @movies = Movie.where(rating: @ratings.keys).order("release_date ASC")
      @release_date_class = "hilite"
    else
      @movies = Movie.where(rating: @ratings.keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
