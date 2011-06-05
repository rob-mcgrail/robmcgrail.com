class String
  def parameterize
    self.gsub(/[^a-z0-9\-_!?]+/i, '-').downcase
  end
end

