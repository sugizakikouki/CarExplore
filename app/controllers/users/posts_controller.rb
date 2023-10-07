class Users::PostsController < ApplicationController
  def index
    # @post = Post.new
    @keyword = params[:keyword]
  
    # タグに関連する投稿を取得するか、すべての投稿を取得するかを決定
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all
  
    # キーワードでの検索が行われた場合、絞り込みを行う
    if @keyword.present?
      @posts = @posts.search(@keyword)
    end
  
    # 投稿を最新のものから表示するために、created_at カラムを降順にソート
    @posts = @posts.order(created_at: :desc).page(params[:page])
    # 各投稿に対するリポスト情報を含める
    @posts.each do |post|
      post.reposts = Post.where(repost_id: post.id)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = Comment.all
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
      flash[:notice] = 'Successfully posted.'
      redirect_to request.referer
    else
      flash[:notice] = 'Posting failed.'
      redirect_to request.referer
    end
  end
  
  def repost_create
    post = Post.find(params[:repost_id])
    ## TODO: repost_idみたいなカラムを作成してrepost元のIDをいれておく
    ##      そうしないと、そのpostが通常投稿なのかリポストなのかがわからない
    #@repost = Post.create!(content: post.content, image: post.images, user_id: current_user.id, repost_id: post.id)
    
    @repost = Post.new
    @repost.content = post.content
    @repost.user_id = current_user.id
    @repost.repost_id = post.id
    
    post.images.each do |image|
      image_file = ActiveStorage::Blob.service.send(:path_for, image.key)
      downloaded_image = open(image_file)
      @repost.images.attach(io: downloaded_image, filename: "image.jpg")
    end
    
    tag_list = post.tags.pluck(:tag_name)
    #pp tag_list
    
    if @repost.save!
      @repost.save_tag(tag_list) unless tag_list == []
      flash[:notice] = 'Successfully reposted.'
    else
      flash[:notice] = 'Repost failed.'
    end
    redirect_to request.referer
  end
  
  def destroy
    post = Post.find(params[:id])
    if current_user == post.user
      post.destroy
      redirect_to request.referer
    else
      flash[:alert] = "他のユーザーの投稿を削除する権限がありません。"
      redirect_to request.referer
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content, images: [])
  end
end
