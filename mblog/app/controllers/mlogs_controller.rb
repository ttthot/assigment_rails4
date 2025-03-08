class MlogsController < ApplicationController
  def index
  end
  def new
    @mlog = Mlog.new
  end

end
