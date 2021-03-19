defmodule ExMon.Repo.Migrations.AddPokemonsTable do
  use Ecto.Migration

  def change do
    # O ecto usa inteiro incremental como primary key por default, mas nós queremos
    # usar UUID, então teremos de desabilitar o default
    create table(:pokemons, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :nickname, :string
      add :weight, :integer
      # o conteúdo de types é: ["bug", "eletric"]
      add :types, {:array, :string}
      # insere automaticamente created_at e updated_at
      timestamps()
      # Cria o campo de relacionamento entre as tabelas
      add :trainer_id, references(:trainers, type: :uuid, on_delete: :delete_all), null: false
    end
  end
end
