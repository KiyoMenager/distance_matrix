defmodule Permutation do
  @moduledoc """
  Functions that work on circular permutation.

  In mathematics, the notion of permutation relates to the act of arranging all
  the members of a set into some sequence or order, or if the set is already
  ordered, rearranging (reordering) its elements, a process called permuting.

  A circular permutation means the last element has for successor the first.
  """

  @typedoc """
  The type of the current module.
  """
  @type t :: []

  @typedoc """
  Element contained by the permutation.
  """
  @type element :: any

  @typedoc """
  Accumulateur used for reductions.
  """
  @type acc :: term

  @doc """
  Returns a list where each item is the result of invoking fun on each
  corresponding edge of permutation.

  Note that since the successeur of the last element in the permutation is the
  first element, the last considered edge is {last, first}

  ## Examples

      iex> Permutation.edge_map([1, 2, 3], &(&1 + &2))
      [3, 5]

      iex> Permutation.edge_map([1, 2, 3], &(&1 + &2), :cyclic)
      [3, 5, 4]

  """
  @spec edge_map(t, (element, element -> any)) :: list
  @spec edge_map(t, (element, element -> any), :cyclic) :: list

  def edge_map([],              _), do: []
  def edge_map(permutation,   fun) do
    edge_reduce(permutation, [], &([fun.(&1, &2) | &3])) |> :lists.reverse()
  end
  def edge_map([],            _, :cyclic), do: []
  def edge_map(permutation, fun, :cyclic) do
    edge_reduce(permutation, [], &([fun.(&1, &2) | &3]), :cyclic) |> :lists.reverse()
  end

  @doc """
  Invokes fun for each edge in the permutation, passing that element and the
  accumulator as arguments. fun’s return value is stored in the accumulator.
  An optional tag :cyclic can be passed, then the fun will invoked on the pair
  Last element, first element.

  ## Examples

      A regular edge reduce:

      iex> Permutation.edge_reduce([1, 2, 3], 0, &(&1 + &2 + &3))
      8
      iex> Permutation.edge_reduce([1, 2, 3], [], &([&1 + &2 | &3]))
      [5, 3]

      A cyclic edge reduce:

      iex> Permutation.edge_reduce([1, 2, 3], 0, &(&1 + &2 + &3), :cyclic)
      12
      iex> Permutation.edge_reduce([1, 2, 3], [], &([&1 + &2 | &3]), :cyclic)
      [4, 5, 3]

  """
  @spec edge_reduce(t, acc, (element, element, acc -> any)) :: list
  @spec edge_reduce(t, acc, (element, element, acc -> any), :cyclic) :: list

  def edge_reduce(permutation, acc, fun) do
    do_edge_reduce(permutation, acc, fun)
  end
  def edge_reduce(permutation, acc, fun, :cyclic) do
     do_edge_reduce(permutation, nil, acc, fun)
  end

  # Regular edge reduce.
  defp do_edge_reduce([],           acc, _), do: acc
  defp do_edge_reduce([pred|succs], acc, fun) do
    case succs do
      []       -> acc
      [succ|_] -> do_edge_reduce(succs, fun.(pred, succ, acc), fun)
    end
  end
  # Cyclic edge reduce. (applies the given fun to the pair {last, first})
  defp do_edge_reduce([],               _, acc, _), do: acc
  defp do_edge_reduce([pred|succs], first, acc, fun) do
    first = first || pred
    case succs do
      [] ->
        fun.(pred, first, acc)
      [succ|_] ->
        do_edge_reduce(succs, first, fun.(pred, succ, acc), fun)
    end
  end

end
