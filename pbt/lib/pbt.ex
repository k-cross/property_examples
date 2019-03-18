defmodule Pbt do
  @moduledoc """
  Documentation for Pbt.
  """

  @doc "Gets the largest element of a non-empty list"
  def biggest([head | tail]), do: biggest(tail, head)

  defp biggest([], max), do: max

  defp biggest([head | tail], max) when head >= max, do: biggest(tail, head)

  defp biggest([head | tail], max) when head < max, do: biggest(tail, max)
end
