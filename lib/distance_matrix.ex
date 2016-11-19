defmodule DistanceMatrix do
  @moduledoc """
  Provide a set of functions to work with a matrix of distances
  (Wrapper of the `TupleMatrix` module).

  A distance matrix is a matrix (two-dimensional array) containing the
  distances, taken pairwise, between the elements of a set (Here a list).

  If there are N elements in the set, this matrix will have size N×N.

  The `DistanceMatrix` struct stores a `length_callback` convenient for
  calculating the length of a given route.

  ## Examples

      iex> route = [
      ...>    DistanceMatrix.Location.new(1, 2),
      ...>    DistanceMatrix.Location.new(2, 4),
      ...>    DistanceMatrix.Location.new(3, 2)
      ...> ]
      iex>
      iex> matrix = DistanceMatrix.new(route)
      iex>
      iex> matrix.length_callback.([1, 2, 0], :cyclic)
      8
      iex> matrix.length_callback.([1, 2, 0], :acyclic)
      5

  """

  alias DistanceMatrix.Localizable

  defstruct [:matrix, :length_callback]
  @type t :: %__MODULE__{
                matrix: TupleMatrix.t(distance),
                length_callback: length_callback
              }
  @type index :: non_neg_integer

  @typedoc """
  The element representing a distance.
  """
  @type distance :: non_neg_integer

  @typedoc """
  A list of `Localizable` from which the distance matrix is build.
  """
  @type route :: list(Localizable.t)

  @type length_callback :: ((route, atom) -> distance)

  @doc """
  Creates a new `DistanceMatrix`  generating for
  each Cij a value resulting from fun(i, j).

  ## Examples

      iex> route = [
      ...>  DistanceMatrix.Location.new(1, 2),
      ...>  DistanceMatrix.Location.new(2, 4),
      ...>  DistanceMatrix.Location.new(3, 2)
      ...>  ]
      iex>
      iex> distance_matrix = DistanceMatrix.new(route)
      iex> distance_matrix.matrix
      %TupleMatrix{tuple: {0, 3, 2, 3, 0, 3, 2, 3, 0}, nb_cols: 3, nb_rows: 3}



      iex> distance_matrix = DistanceMatrix.new([])
      iex> distance_matrix.matrix
      %TupleMatrix{tuple: {}, nb_cols: 0, nb_rows: 0}

  """
  @spec new(route) :: t

  def new(route) do
    route = List.to_tuple(route)
    size = tuple_size(route)
    producer = distance_producer(route)
    matrix = TupleMatrix.new(size, size, producer)

    %__MODULE__{
      matrix: matrix,
      length_callback: length_callback(matrix)
    }
  end

  @doc """
  Gets the distance at {`row`, `col`} in the given `distances_matrix`

  ## Examples

      iex> alias DistanceMatrix.Location
      iex> route = [Location.new(1, 2), Location.new(2, 4), Location.new(3, 2)]
      iex> d_m = DistanceMatrix.new(route)
      iex> d_m |> DistanceMatrix.get(1, 2)
      3

  """
  def get(%{matrix: matrix}, row, col), do: TupleMatrix.at(matrix, row, col)


  # Returns a function that compute the distance between `node` located at `i`
  # and `j` in the given `permutation`.
  #
  # Used to populate the `distance_matrix`.
  #
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

  # Returns a function fun/2 that calculate the sum of the distances between
  # each element taken pairwise.
  #
  # Elements has to implement the `Localizable` protocole.
  #
  # - First parameter is the `route` (list of `Localizable`).
  # - Second parameter is a tag to know if the length should be calculated
  #   considering the route cyclic (:cyclic) or not (:acyclic)
  #
  @spec length_callback(t) :: length_callback

  defp length_callback(matrix) do
    reducer = &(&3 + (matrix |> TupleMatrix.at(&1, &2)))
    fn
      route, :acyclic  -> Permutation.edge_reduce(route, 0, reducer)
      route, :cyclic  -> Permutation.edge_reduce(route, 0, reducer, :cyclic)
    end
  end

end
