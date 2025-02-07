class NoticesController < ApplicationController
  #before_action :authenticate_admin_user!, except: [:index, :show]
  #load_and_authorize_resource

  def index
    @notices = Notice.all
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)
    @notice.admin_user = current_admin_user.id
    if @notice.save
      redirect_to admin_notices_path, notice: 'Notice was successfully created.'
    else
      render :new
    end
  end
  
  def edit
    @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])
    if @notice.update(notice_params)
      redirect_to admin_notice_path(@notice), notice: 'Notice was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy
    redirect_to admin_notices_path, notice: 'Notice was successfully deleted.'
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :body)
  end
end
