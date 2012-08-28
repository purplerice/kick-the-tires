class CitiesController < ApplicationController

  before_filter :find_city, :only => [ :show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      #@cities = City.near(params[:search], nil, :order => :distance)
      @cities = City.search(params[:search])
      #@cities = City.near(params[:search], :order => :distance)
    else
    @cities = City.all
    end
  end

  def show
    @nearest_ten = @city.nearbys

    respond_to do |format|
      format.html
    end

  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        flash.now[:success] = "City saved successfully!!"
        format.html { redirect_to @city, notice: "Successfully created city." }
        format.json { render json: @city, status: :created, location: @city }
      else
        flash.now[:error]=@city.errors.full_messages
        format.html { render action: "new" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @city.update_attributes(params[:city])
      redirect_to @city, :notice => "Successfully updated city."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_url, :notice => "Successfully destroyed city."
  end

  def find_city
    @city = City.find(params[:id])
  end
end
