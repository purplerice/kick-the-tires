class CitiesController < ApplicationController

  before_filter :find_city, :only => [:edit, :update, :destroy, :viewcity, :add_tag]

  def search
    if params[:search].present?
      by_what = params[:radio_button] == 'search_by_name' ? 'name' : 'tag'
      @cities = City.search(params[:search],by_what)
    else
      @cities = City.all
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    if params[:search].present?
      #by_what = params[:search_by_name].present? ? 'name' : 'tag'
      by_what = params[:search_by] == 'search_by_name' ? 'name' : 'tag'
      @cities = City.search(params[:search],by_what )

    else
      @cities = City.all
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  #def show
  #  @nearest_ten = @city.nearbys
  #
  #  respond_to do |format|
  #    format.html
  #  end
  #
  #end

  def viewcity
    @nearest_ten = @city.nearbys

    respond_to do |format|
      format.html
    end

  end

  def new
    @city = City.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        flash.now[:success] = "City saved successfully!!"
        format.html { redirect_to viewcity_path(@city), notice: "Successfully created city." }
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
    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to viewcity_path(@city), :notice => "Successfully updated city." }
      else
        format.html { render :action => 'edit' }
      end
    end

  end

  def destroy
    @city.destroy
    respond_to do |format|
      format.html {redirect_to cities_url, :notice => "Successfully destroyed city."}
    end
  end

  def clear_fields
    @cities = City.all

    respond_to do |format|
      format.js
    end
  end

  def add_tag
    respond_to do |format|
      format.js
    end
  end

  protected

  def find_city
    @city = City.find(params[:id])
  end
end
