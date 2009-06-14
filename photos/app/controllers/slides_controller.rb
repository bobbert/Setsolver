class SlidesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @slide_pages, @slides = paginate :slides, :per_page => 10
  end

  def show
    @slide = Slide.find(params[:id])
  end

  def new
    @slide = Slide.new
  end

  def create
    @slide = Slide.new(params[:slide])
    if @slide.save
      flash[:notice] = 'Slide was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @slide = Slide.find(params[:id])
  end

  def update
    @slide = Slide.find(params[:id])
    if @slide.update_attributes(params[:slide])
      flash[:notice] = 'Slide was successfully updated.'
      redirect_to :action => 'show', :id => @slide
    else
      render :action => 'edit'
    end
  end

  def destroy
    Slide.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
