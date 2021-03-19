defmodule ExMon.Trainer.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  # lib/ex_mon/trainer.ex
  alias ExMon.Trainer

  # Definir a PK porque optamos por criar uma PK de UUID ( não aceitamos o padrão int autoincrementado)
  # @primary_key {:trainer_id, Ecto.UUID, autogenerate: true}
  # Aqui é o campo id da tabela pokemons!!! Cuidado!!!!!
  @primary_key {:id, Ecto.UUID, autogenerate: true}

  # Acompanhar o que ´foi definido na migration ExMon.Repo.Migrations.AddPokemonsTable
  @foreign_key_type Ecto.UUID

  # O mesmo que está em PROJ/priv/repo/migrations/
  schema "pokemons" do
    field :name, :string
    field :nickname, :string
    field :weight, :integer
    field :types, {:array, :string}
    # Implementa o relacionamento apontando a tabela e o módulo (use alias acima)
    # Em lib/ex_mon/trainer.ex tem que explícitar o tipo do relacionamento (por exemplo: has_many ou has_one)
    # Os parâmetros do has_many(nome_do_esquema, módulo)
    belongs_to(:trainer, Trainer)
    timestamps()
  end

  @required_params [:name, :nickname, :weight, :types, :trainer_id]

  # Fazer as validações sem ter que ir até o database para obter o erro 
  def build(params) do
    params
    |> changeset()
    # Passando o resultado de changeset e o atom :insert (poderia ser qualquer atom)
    # A função apply_action recebe obrigatoriamente um changeset
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:nickname, min: 2)
  end

  # Em lib/ex_mon_web/controllers/trainer_pokemons_controller.ex
  # Como parte dos campos vem de API (ou seja, não podem ser modificados), parte são automáticos
  # (id, id_trainer e timestamps), só resta o campo nickname para ser alterado.
  # Portanto, se a gente olhar no Schema em lib/ex_mon/trainer/pokemon.ex vemos um changeset
  # com Required para todos os campos de input e isso vai dar problema aqui.
  # Então a solução é criar um novo changeset chamado update_changeset(pokemon, params).
  def update_changeset(pokemon, params) do
    pokemon
    |> cast(params, [:nickname])
    |> validate_required([:nickname])
    |> validate_length(:nickname, min: 2)
  end
end
