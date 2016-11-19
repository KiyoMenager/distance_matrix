defmodule PermutationTest do
  use ExUnit.Case
  doctest Permutation

  @permutation [1, 2, 3, 4]

  test "Permutation.map returns [] if given permutation []" do
    func = fn edge_x, edge_y -> edge_x + edge_y end
    assert Permutation.edge_map([], func) == []
    assert Permutation.edge_map([], func, :cyclic)  == []
  end

  test "cyclic Permutation.map returns [] if given permutation [1]" do
    func = fn edge_x, edge_y -> edge_x + edge_y end

    single_elem = 3
    permutation = [single_elem]
    expected    = [func.(single_elem, single_elem)]

    assert Permutation.edge_map(permutation, func, :cyclic) == expected
  end

  test "acyclic Permutation.map returns [] if given permutation [1]" do
    func = fn edge_x, edge_y -> edge_x + edge_y end

    single_elem = 3
    permutation = [single_elem]
    expected    = []

    assert Permutation.edge_map(permutation, func) == expected
  end
end
