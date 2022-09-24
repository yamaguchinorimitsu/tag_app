class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
   # @postから情報をハッシュとして取り出し、@post_formとしてインスタンス生成する
    post_attributes = @post.attributes
     @post_form = PostForm.new(post_attributes)
     @post_form.tag_name = @post.tags&.first&.tag_name
  end

  def update
    # paramsの内容を反映したインスタンスを生成する
    @post_form = PostForm.new(post_form_params)
  
    # 画像を選択し直していない場合は、既存の画像をセットする
    @post_form.image ||= @post.image.blob


    if @post_form.valid?
      #①コントローラーでupdateメソッドを呼び出す
      @post_form.update(post_form_params, @post)
      redirect_to root_path
    else
      render :edit
    end
  end

  #検索用のサーチアクション追加
  #52行目で、もしフォームの入力内容が空であれば、Javascriptにnilを返すという処理を記述しています。
  #53行目で、フォームの入力内容をもとに、whereメソッドとLIKE句を使用して、あいまい検索をしています。
  #もしDB内に一致するものがあれば、変数tagに情報を代入しています。
  #54行目で、json形式で、10行目の変数tagの情報をJavascriptに返します。
  def search
    return nil if params[:keyword] == ""
    tag = Tag.where(['tag_name LIKE ?', "%#{params[:keyword]}%"] )
    render json:{ keyword: tag }
  end

  private
  def post_form_params
    params.require(:post_form).permit(:text, :tag_name, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
