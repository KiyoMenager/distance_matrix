defmodule DistanceMatrix do
  @moduledoc """
  Provide a set of functions to work with a matrix of distances
  (Wrapper of the `TupleMatrix` module).

  A distance matrix is a matrix (two-dimensional array) containing the
  distances, taken pairwise, between the elements of a set (Here a list).

  If there are N elements in the set, this matrix will have size N×N.

  """

  alias DistanceMatrix.Localizable

  @type t :: TupleMatrix.t(distance)
  @type index :: non_neg_integer

  @typedoc """
  The element representing a distance.
  """
  @type distance :: non_neg_integer

  @typedoc """
  A list of `Localizable` from which the distance matrix is build.
  """
  @type route :: list(Localizable.t)

  @type distance_callback :: ((index, index) -> distance)
                          |  (route -> distance)

  @doc """
  Creates a new `DistanceMatrix`  generating for
  each Cij a value resulting from fun(i, j).

  ## Examples

      iex> alias DistanceMatrix.Location
      iex>
      iex> DistanceMatrix.create([Location.new(1, 2), Location.new(2, 4), Location.new(3, 2)])
      %TupleMatrix{tuple: {0, 3, 2, 3, 0, 3, 2, 3, 0}, nb_cols: 3, nb_rows: 3}
      iex>
      iex> DistanceMatrix.create([])
      %TupleMatrix{tuple: {}, nb_cols: 0, nb_rows: 0}

  """
  @spec create(route) :: t

  def create(route) do
    route = List.to_tuple(route)
    size = tuple_size(route)
    producer = distance_producer(route)
    TupleMatrix.new(size, size, producer)
  end

  @doc """
  Gets the distance at {`row`, `col`} in the given `distances_matrix`

  ## Examples

      iex> alias DistanceMatrix.Location
      iex> route = [Location.new(1, 2), Location.new(2, 4), Location.new(3, 2)]
      iex> d_m = DistanceMatrix.create(route)
      iex> d_m |> DistanceMatrix.get(1, 2)
      3

  """
  defdelegate get(distances_matrix, row, col), to: TupleMatrix, as: :at


  # Returns a function that compute the distance between `node` located at `i`
  # and `j` in the given `permutation`.

  @spec distance_producer(route) :: TupleMatrix.producer

  defp distance_producer(route) do
    fn i, j ->
      cond do
        i == j     -> 0
        :otherwise ->
          i_node = elem(route, i)
          j_node = elem(route, j)

          i_node |> Localizable.distance(j_node)
      end
    end
  end


  @doc """
  Returns a callable function to get the total distance of a route according
  to the given `matrix`.

  ## Examples

      iex> route = [
      ...>    DistanceMatrix.Location.new(1, 2),
      ...>    DistanceMatrix.Location.new(2, 4),
      ...>    DistanceMatrix.Location.new(3, 2)
      ...> ]
      iex>
      iex> matrix = DistanceMatrix.create(route)
      iex>
      iex> callback = DistanceMatrix.route_lenght_callback(matrix)
      iex> callback.([1, 2, 0], :cyclic)
      8
      iex> callback.([1, 2, 0], :acyclic)
      5

  """
  @spec route_lenght_callback(t) :: distance_callback

  def route_lenght_callback(distance_matrix) do
    reducer =
      fn idx_pred, idx_succ, acc ->
        acc + (distance_matrix |> get(idx_pred, idx_succ))
      end

    fn
      route, :acyclic ->
        Permutation.edge_reduce(route, 0, reducer)
      route, :cyclic ->
        Permutation.edge_reduce(route, 0, reducer, :cyclic)
    end
  end

end
