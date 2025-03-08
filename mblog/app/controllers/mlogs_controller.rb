class MlogsController < ApplicationController
  def index
    @mlogs = Mlog.all
  end

  def new
    @mlog = Mlog.new
  end

  def create
    @mlog = Mlog.new(mlog_params)
    if @mlog.save
      redirect_to mlogs_path, notice: "Mlog was successfully created."
    else
      render :new
    end
  end

  def show
    @mlog = Mlog.find(params[:id])
  end

  def edit
    @mlog = Mlog.find(params[:id])
  end

  def update
    @mlog = Mlog.find(params[:id])
    if @mlog.update(mlog_params)
      redirect_to mlogs_path, notice: "Mlog was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @mlog = Mlog.find(params[:id])
    @mlog.destroy
    redirect_to mlogs_path, notice: "Mlog was successfully destroyed."
  end

  private

  def mlog_params
    params.require(:mlog).permit(:title, :description, :content, :tags)
  end
end
