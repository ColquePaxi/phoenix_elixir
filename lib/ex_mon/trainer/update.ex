defmodule ExMon.Trainer.Update do
  alias ExMon.{Repo, Trainer}
  alias Ecto.UUID

  def call(%{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, "Invalid Id format"}
      {:ok, _uuid} -> update(params)
    end
  end

  defp update(%{"id" => uuid} = params) do
    case fetch_trainer_uuid(uuid) do
      nil -> {:error, "Trainer not found"}
      trainer -> update_trainer(trainer, params)
    end
  end

  defp fetch_trainer_uuid(uuid), do: Repo.get(Trainer, uuid)

  # Está recebendo 2 parâmetros (trainer e params) então vai chamar a função 
  # def changeset(params, trainer), do: create_changeset(trainer, params) lá do trainer.ex 
  # que foi criada especificamente para update
  defp update_trainer(trainer, params) do
    trainer
    |> Trainer.changeset(params)
    |> Repo.update()
  end
end
