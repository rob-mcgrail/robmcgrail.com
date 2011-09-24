class BlogPost
  include DataMapper::Resource
  include SolrHelpers
  #include Solrable

  property :id,         Serial # primary serial key
  property :title,      String,  :required => true,  :length => 100
  property :slug,       String,  :required => true,  :length => 100
  property :body,       Text,     :required => true,  :length => 100000
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

  def delete_path
    '/blog/delete/' + self.id.to_s
  end
  
  def tags_csv
    a = self.tags
    a.inject('') do |sum, n|
      sum += ', ' unless sum == ''
      sum + n.name
    end
  end
  
  def to_solr
    SolrHelpers.update(self.to_xml)
  end
  
  def to_xml
    SolrHelpers.xml self, {:id => 'id',
                            :title => 'title',
                            :slug => 'slug',
                            :body => 'body',
                            :category => 'category',
                            :keywords => 'tags_csv',
                            :created_at => 'created_at',
                            :updated_at => 'updated_at'}
  end
end

###############
# View Routes #
###############

get '/blog/?' do
  authorize!
  @title = title 'blog'

  @posts = BlogPost.all(:order => [ :created_at.desc ])

  haml :'blog/index'
end

###### Code

get '/code/?' do
  @title = title 'code'

  @intro = "h2. Code\n\nFull of bad advice and things that don't work.\n\n"

  @posts = BlogPost.of_category 'code'
  
  haml :'blog/index'
end



get '/code/:slug/?' do
  @title = title 'code'

  @post = BlogPost.of_category('code').first(:slug => params[:slug])

  @post.to_solr

  haml :'blog/show'
end

###### USA

get '/usa/?' do
  @title = title 'usa'

  @intro = "h2. usa\n\n"

  @posts = BlogPost.of_category 'usa'
  haml :'blog/index'
end


get '/usa/:slug/?' do
  @title = title 'usa'

  @post = BlogPost.of_category('usa').first(:slug => params[:slug])

  haml :'blog/show'
end

###### Things

get '/things/?' do
  @title = title 'things'

  @intro = "h2. Things\n\n...\n\n"

  @posts = BlogPost.of_category 'things'
  haml :'blog/index'
end



get '/things/:slug/?' do
  @title = title 'things'

  @post = BlogPost.of_category('things').first(:slug => params[:slug])

  haml :'blog/show'
end


####### Tags


get '/tag/:tag/?' do
  @title = title params[:tag]
  @intro = "h2. ##{params[:tag]}"

  @posts = BlogPost.tagged_with(params[:tag], :order => [ :created_at.desc ])

  haml :'blog/index'
end


get '/:category/tag/:tag/?' do
  @title = title params[:tag]
  @intro = "h2. #{params[:category]}:##{params[:tag]}"

  @posts = BlogPost.of_category(params[:category]).tagged_with(params[:tag], :order => [ :created_at.desc ])

  haml :'blog/index'
end

#################
# Create Routes #
#################

get '/blog/new-post/?' do
  authorize!
  @title = title 'new blog post'
  haml :'blog/new'
end


post '/blog/new-post/?' do
  authorize!
  @post = BlogPost.new(
    :title => params[:title],
    :slug => params[:title].parameterize,
    :body  => params[:body],
    :category  => params[:category],
    :tag_list => params[:tags],
    :created_at => Time.now
  )

  if @post.save
    flash[:success] = 'Post created.'
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
  authorize!
  @post = BlogPost.get(params[:id])

  @title = title 'edit ' + @post.title

  haml :'blog/edit'
end


post '/blog/edit/:id/?' do
  authorize!
  @post = BlogPost.get(params[:id])
  @post.title = params[:title]
  @post.slug = params[:slug]
  @post.body = params[:body]
  @post.category = params[:category]
  @post.tag_list = params[:tags]
  @post.updated_at = Time.now

  if @post.save
    flash[:success] = 'Post updated.'
    redirect @post.slug_path
  else
    flash[:error] = 'Failed to update.'
    redirect "blog/edit/#{@post.id}"
  end
end

###############
# Delete      #
###############

delete '/blog/:id/?' do
  authorize!
  @post = BlogPost.get(params[:id])

  cat = @post.category

  if @post.destroy
    flash[:success] = 'Post deleted.'
    redirect "/#{cat}"
  else
    flash[:error] = 'Failed to delete.'
    redirect @post.slug_path
  end
end

