# DistanceMatrix

This utility project provides a set of functions to work with a matrix of
distances.

A distance matrix is a matrix containing the distances, taken pairwise,
between the elements of a set (Here a list).

If there are N elements in the set, this matrix will have size N×N.

Because the distance_matrix need to calculate the distance between each pair of
elements, elements have to implement the [Localizable](https://github.com/KiyoMenager/distance_matrix/blob/master/lib/localizable.ex) protocol.
See [Location](https://github.com/KiyoMenager/distance_matrix/blob/master/lib/location.ex) for example.

  ```elixir
  [Location.new(1, 2), Location.new(2, 4), Location.new(3, 2)]
  |> DistanceMatrix.create
  |> DistanceMatrix.get(0, 2)
  #=> 3
  ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `distance_matrix` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:distance_matrix, "~> 0.1.0"}]
    end
    ```

  2. Ensure `distance_matrix` is started before your application:

    ```elixir
    def application do
      [applications: [:distance_matrix]]
    end
    ```
