defmodule ExMon.Trainer.Pokemon.Get do
  alias ExMon.{Repo, Trainer.Pokemon}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid Id format"}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, "Pokemon not found"}
      # Preload() traz as ASSOCIAÇÕES que foram definidas no Schema
      # E também faz 2 query (uma do Pokemon e outra do Trainer ao qual está vinculado)
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)}
    end
  end
end
