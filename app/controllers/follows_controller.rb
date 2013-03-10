class FollowsController < ApplicationController
  prepend_before_filter :current_user, :only => :exhibit
  before_filter :authenticate_user!

  def follow
    @following_user_id = params[:following_user_id]
    Follow.create(user_id: params[:user_id], following_user_id: params[:following_user_id])
    respond_to { |format| format.js }
  end

  def unfollow
    @following_user_id = params[:following_user_id]
    Follow.where('user_id = ? AND following_user_id = ?', params[:user_id], params[:following_user_id]).each do |f|
      f.destroy
    end
    respond_to { |format| format.js }
  end

  def following
    @following = User.joins('INNER JOIN follows ON follows.following_user_id = users.id').where('user_id = ?', params[:id])
  end
end
