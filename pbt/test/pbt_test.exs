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

  defp model_biggest(list), do: List.last(Enum.sort(list))

  defp is_ordered([a, b | t]) do
    a <= b and is_ordered([b | t])
  end

  # anything with less than 2 elements is sorted.
  defp is_ordered(_) do
    true
  end
end
