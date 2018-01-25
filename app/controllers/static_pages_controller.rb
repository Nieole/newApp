class StaticPagesController < ApplicationController
  def home
    #异步调用GuestsCleanupJob内perform方法
    GuestsCleanupJob.perform_later
    if logged_in?
      @micropost=current_user.microposts.build if logged_in?
      @feed_items=current_user.feed.paginate(page:params[:page])
    end
  end

  def help
  end

  def about

  end
  def contact

  end
end
