defmodule ExMon.Repo.Migrations.CreateTrainerTable do
  use Ecto.Migration

  def change do
    # O ecto usa inteiro incremental como primary key por default, mas nós queremos
    # usar UUID, então teremos de desabilitar o default
    create table(:trainers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :password_hash, :string
      timestamps() # insere automaticamente created_at e updated_at
    end
  end
end
