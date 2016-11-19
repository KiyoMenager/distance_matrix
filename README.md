# DistanceMatrix

This utility project provides a set of functions to work with a matrix of
distances.

A distance matrix is a matrix containing the distances, taken pairwise,
between the elements of a set (Here a list).

If there are N elements in the set, this matrix will have size N×N.

Because the distance_matrix need to calculate the distance between each pair of
elements, elements have to implement the [Localizable](https://github.com/KiyoMenager/distance_matrix/blob/master/lib/localizable.ex) protocol.
See [Location](https://github.com/KiyoMenager/distance_matrix/blob/master/lib/location.ex) for example.

## Usage

```elixir
[Location.new(1, 2), Location.new(2, 4), Location.new(3, 2)]
|> DistanceMatrix.new
|> DistanceMatrix.get(0, 2)
#=> 3
```

Note you can use convenient callback stored in the DistanceMatrix struct while
created.

```elixir
route = [Location.new(1, 2), Location.new(2, 4), Location.new(3, 2)]
distance_matrix = DistanceMatrix.new(route)
distance_matrix.length_callback.([1, 2, 0], :cyclic)
#=> 8
distance_matrix.length_callback.([1, 2, 0], :acyclic)
#=> 5
```

## Localizable

The localizable protocol should be implemented by any module meant to be used by
the distance_matrix api. See [Localizable](https://github.com/KiyoMenager/distance_matrix/blob/master/lib/localizable.ex) protocol.

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
