class Users::PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.page(params[:page])
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
    @repost.user_id = post.user_id
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
    post.destroy
    redirect_to request.referer
  end
  
  def search
    @results = @a.result(distinct: true).page(params[:page]).per(10).order('created_at DESC')
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content, images: [])
  end
  
  def search_article
    @a = Article.ransack(params[:q])
  end
end
