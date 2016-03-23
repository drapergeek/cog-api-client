defmodule CogApi.Resources.Bundle do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :enabled,
    :name,
    :inserted_at,
    :updated_at,
    commands: [%CogApi.Resources.Command{}],
  ]

  def decode_status("enabled"), do: true
  def decode_status("disabled"), do: false

  def encode_status("true"), do: "enabled"
  def encode_status(true), do: "enabled"
  def encode_status(_), do: "disabled"
end
