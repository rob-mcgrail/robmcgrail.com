class BlogPost
  include DataMapper::Resource

  property :id,         Serial # primary serial key
  property :title,      String,  :required => true,  :length => 32
  property :slug,       String,  :required => true,  :length => 32
  property :body,       Text,     :required => true,  :length => 10000
  property :category,   String,  :required => true,  :length => 10, :lazy => false
  property :created_at, DateTime,:required => true
  property :updated_at, DateTime

  has_tags_on :tags

  def self.of_category(cat)
    all(:category => cat, :order => [ :created_at.desc ])
  end

  def slug_path
    '/' + self.category.parameterize + '/' + self.slug
  end

  def edit_path
    '/blog/edit/' + self.id.to_s
  end
end

###############
# View Routes #
###############

get '/blog/?' do
  @title = title 'blog'

  @posts = BlogPost.all(:order => [ :created_at.desc ])

  haml :'blog/index'
end


get '/code/?' do
  @title = title 'code'
  @posts = BlogPost.of_category 'code'
  haml :'blog/index'
end


get '/code/:slug/?' do
  @title = title 'code'

  @post = BlogPost.of_category('code').first(:slug => params[:slug])

  haml :'blog/show'
end


get '/tag/:tag/?' do
  @title = title params[:tag]

  @posts = BlogPost.tagged_with(params[:tag], :order => [ :created_at.desc ])

  haml :'blog/index'
end

#################
# Create Routes #
#################

get '/blog/new-post/?' do
  @title = title 'new blog post'
  haml :'blog/new'
end


post '/blog/new-post/?' do
  @post = BlogPost.new(
    :title => params[:title],
    :slug => params[:title].parameterize,
    :body  => params[:body],
    :category  => params[:category],
    :tag_list => params[:tags],
    :created_at => Time.now
  )

  if @post.save
    flash[:main] = 'Post created.'
    redirect @post.slug_path
  else
    flash[:error] = 'Failed to create post.'
    redirect 'blog/new-post'
  end
end

###############
# Edit Routes #
###############

get '/blog/edit/:id/?' do
  @post = BlogPost.get(params[:id])

  @title = title 'edit ' + @post.title

  haml :'blog/edit'
end


post '/blog/edit/:id/?' do
  @post = BlogPost.get(params[:id])
  @post.title = params[:title]
  @post.slug = params[:slug]
  @post.body = params[:body]
  @post.category = params[:category]
  @post.tag_list = params[:tags]
  @post.updated_at = Time.now

  if @post.save
    flash[:main] = 'Post updated.'
    redirect @post.slug_path
  else
    flash[:error] = 'Failed to update.'
    redirect "blog/edit/#{@post.id}"
  end
end

