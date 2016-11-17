defprotocol DistanceMatrix.Localizable do
  
  @doc "Returns the distance between `fst_node` and `sec_node`"
  def distance(fst_node, sec_node)
end
