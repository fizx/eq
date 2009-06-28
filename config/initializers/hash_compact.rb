class Hash
  def hash_compact
    self.inject(self.class.new) do |memo, (k, v)|
      memo[k] = v if v
      memo
    end
  end
end