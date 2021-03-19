defmodule ExMon.Trainer.Pokemon.Update do
  alias ExMon.{Repo, Trainer.Pokemon}
  alias Ecto.UUID

  def call(%{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, "Invalid Id format"}
      {:ok, _uuid} -> update(params)
    end
  end

  defp update(%{"id" => uuid} = params) do
    # case fetch_trainer_pokemon(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, "Pokemon not found"}
      pokemon -> update_trainer_pokemon(pokemon, params)
    end
  end

  # Como só chamada um comando, vamos usá-lo diretamente na chamada defp update()
  # defp fetch_trainer_pokemon(uuid), do: Repo.get(Pokemon, uuid)

  # Está recebendo 2 parâmetros (pokemon e params) então vai chamar a função 
  # def changeset(params, pokemon), do: create_changeset(pokemon, params) lá do trainer.ex 
  # que foi criada especificamente para update
  defp update_trainer_pokemon(pokemon, params) do
    pokemon
    # Que foi criada especificamente para alterar o nickname em lib/ex_mon/trainer/pokemon.ex
    |> Pokemon.update_changeset(params)
    |> Repo.update()
  end
end
