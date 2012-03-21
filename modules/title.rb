helpers do
  def title(*arg)
    sitename = 'robmcgrail.com'
    if arg[0]
      sitename = sitename + ' | ' + arg[0]
    end
    @title = sitename
  end
end
