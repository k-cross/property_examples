defmodule PbtTest do
  use ExUnit.Case
  use PropCheck

  property "biggest - modeling example" do
    forall list <- non_empty(list(number())) do
      Pbt.biggest(list) == model_biggest(list)
    end
  end

  property "list last - generalizing example" do
    forall {list, known_last} <- {list(any()), any()} do
      known_list = list ++ [known_last]
      List.last(known_list) == known_last
    end
  end

  property "ordered list - invariant example" do
    forall list <- list(term()) do
      sorted_list = Enum.sort(list)

      is_ordered(sorted_list)
      length(list) == length(sorted_list)
    end
  end

  property "collect example - statistics", [:verbose] do
    forall bin <- binary() do
      collect(is_binary(bin), to_range(10, byte_size(bin)))
    end
  end

  property "aggregate example - statistics", [:verbose] do
    suits = [:club, :diamond, :heart, :spade]

    forall hand <- vector(5, {oneof(suits), choose(1, 13)}) do
      aggregate(true, hand)
    end
  end

  property "resize example", [:verbose] do
    forall str <- sized(s, resize(s * 12, utf8())) do
      collect(is_binary(str), to_range(10, String.length(str)))
    end
  end

  property "let macro example" do
    forall q <- queue() do
      :queue.is_queue(q)
    end
  end

  property "such_that macro example" do
    forall n <- odd() do
      is_integer(n)
    end
  end

  property "frequency macro example" do
    forall n <- text_like() do
      is_binary(n)
    end
  end

  ### Generator Examples

  defp oneof_generator(), do: oneof([range(1, 10), binary()])

  defp queue() do
    let list <- list({term(), term()}) do
      :queue.from_list(list)
    end
  end

  defp odd() do
    such_that(n <- integer(), when: Integer.mod(n, 2) == 1)
  end

  defp text_like() do
    let l <-
          list(
            frequency([
              {2, range(?A, ?Z)},
              {80, range(?a, ?z)},
              {10, ?\s},
              {1, ?\n},
              {1, oneof([?., ?,, ?!, ??, ?-])},
              {1, range(?0, ?9)}
            ])
          ) do
      to_string(l)
    end
  end

  ### Model Function Examples

  defp model_biggest(list), do: List.last(Enum.sort(list))

  ### Invariant Property Examples

  defp is_ordered([a, b | t]) do
    a <= b and is_ordered([b | t])
  end

  # anything with less than 2 elements is sorted.
  defp is_ordered(_) do
    true
  end

  ### Staticstic Helpers

  defp to_range(m, n) do
    base = div(n, m)
    {base * m, (base + 1) * m}
  end
end
