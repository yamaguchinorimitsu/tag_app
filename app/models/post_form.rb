class PostForm
  include ActiveModel::Model

  #PostFormクラスのオブジェクトがPostモデルの属性を扱えるようにする
  attr_accessor(
    :text, :image,
    :id, :created_at, :datetime, :updated_at, :datetime,
    :tag_name
    )

  with_options presence: true do
    validates :text
    validates :image
  end

 
  def save
  #1行目で、保存したpostのレコードを変数postに代入する処理を追加しています。
  #2行目で、tagが重複して保存されることを防ぐため、first_or_initializeメソッドを使用します。
  #3行目で、tagとpostの紐付けの情報を、中間テーブルに保存しています。
    post = Post.create(text: text, image: image)
    tag = Tag.where(tag_name: tag_name).first_or_initialize
    tag.save
    PostTagRelation.create(post_id: post.id, tag_id: tag.id)
  end


  #②post_formモデルで、updateメソッドを定義　①はコントローラー
  #38行目：タグを上書きするため、destroy_allメソッドを用いて、すでに保存されているタグの情報を一度消します。
  #41行目：deleteメソッドを用いて、paramsからタグの情報を削除しています。
  #それと同時に返り値としてタグの情報が返ってくるため、変数tag_nameに代入しています。タグの情報がないときは、nilが返り値となります。
  #44行目：タグの重複保存を避けるため、first_or_initializeメソッドを用いて、変数tagにタグの情報を代入します。
  #47行目〜49行目：タグをTagモデルに保存、テキストと画像をPostモデルに保存、紐付けの情報を中間テーブルに保存しています。

  def update(params, post)
   #一度タグの紐付けを消す
   post.post_tag_relations.destroy_all

   #paramsの中のタグの情報を削除。同時に、返り値としてタグの情報を変数に代入
   tag_name = params.delete(:tag_name)

   #もしタグの情報がすでに保存されていればインスタンスを取得、無ければインスタンスを新規作成
   tag = Tag.where(tag_name: tag_name).first_or_initialize if tag_name.present?

   #タグを保存
   tag.save if tag_name.present?
   post.update(params)
   PostTagRelation.create(post_id: post.id, tag_id: tag.id) if tag_name.present?
  end

end