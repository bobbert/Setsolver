class SlideshowsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @slideshow_pages, @slideshows = paginate :slideshows, :per_page => 10
  end

  def show
    @slideshow = Slideshow.find(params[:id])
  end

  def new
    @slideshow = Slideshow.new
  end

  def create
    @slideshow = Slideshow.new(params[:slideshow])
    if @slideshow.save
      flash[:notice] = 'Slideshow was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @slideshow = Slideshow.find(params[:id])
  end

  def update
    @slideshow = Slideshow.find(params[:id])
    if @slideshow.update_attributes(params[:slideshow])
      flash[:notice] = 'Slideshow was successfully updated.'
      redirect_to :action => 'show', :id => @slideshow
    else
      render :action => 'edit'
    end
  end

  def destroy
    Slideshow.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
