defmodule DistanceMatrix.Location do
  @moduledoc """
  An example module to showcase the matrix creation.
  This module must implements the `Localizable` protocol in order to be used by
  DistanceMatrix.
  """
  defstruct [:x, :y]
  @type t :: %__MODULE__{x: float, y: float}

  @doc """
  Creates a new `Location` passing the coordinates `x`, `y`.
  """
  @spec new(float, float) :: t

  def new(x, y), do: %__MODULE__{x: x, y: y}
end


defimpl DistanceMatrix.Localizable, for: DistanceMatrix.Location do
  @moduledoc """
  The implementation of the `Localizable` protocol for the module `Location`.
  """
  alias DistanceMatrix.Location

  @doc """
  Calculates the manathan distance between 2 nodes.

  ## Examples
      iex> fst = DistanceMatrix.Location.new(2, 3)
      iex> sec = DistanceMatrix.Location.new(2, 6)
      iex> DistanceMatrix.Localizable.distance(fst, sec)
      0
  """
  @spec distance(Location.t, Location.t) :: non_neg_integer

  def distance(%Location{x: fst_x, y: fst_y}, %Location{x: sec_x, y: sec_y}) do
    (:erlang.abs(sec_x - fst_x)) + (:erlang.abs(sec_y - fst_y))
  end
end
