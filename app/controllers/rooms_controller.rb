class RoomsController < ApplicationController
  before_action :redirect_root

  def create
    post = Post.find(params[:post_id])
    @room = current_user.rooms.new(post_id: params[:post_id])
    @room.post_id = post.id

    ActiveRecord::Base.transaction do
      @room.save
      @entry = Entry.new(user_id: current_user.id, room_id: @room.id)
      @entry.save
    end
      flash[:success] = "#{post.title}のチャットを作成しました。"
      redirect_to room_path(@room)
    rescue => e
      flash[:danger] = "チャットの作成に失敗しました。もう一度やり直してください。"
     redirect_to post_path(post)
  end

  def join
    @room = Room.find(params[:id])
    @entry = Entry.new(user_id: current_user.id, room_id: @room.id)

    if @room.post.limit > @room.users.count.to_i

      if @entry.save
        flash[:success] = "#{@room.post.title}のチャットに参加しました！"
        redirect_to room_path(@room)
      else
        flash[:danger] = "チャットに参加できませんでした。"
      end

    else
      flash[:danger] = "#{@room.post.title}は制限人数に達しています！"
      redirect_to post_path(@room.post)
    end
  end

  def show
    @room = Room.find(params[:id])
    @message = Message.new
    # メッセージ相手を抽出
    @another_entry = @room.entries.find_by('user_id != ?', current_user.id)

    @meeting_at = @room.post.meeting_at
    by_time = (@meeting_at - Time.current)
    @by_time = (Time.parse("1/1") + by_time - (day = by_time.to_i / 86400) * 86400).strftime("#{day}日%H時間%M分")
  end

  private
  def redirect_root
    unless logged_in?
      flash[:success] = "ログインまたは、新規登録を行なってください。"
      redirect_to root_path
    end
  end

  def room_params
    params.require(:room).permit(user_ids: [])
  end

end
