defmodule ExMon.Trainer do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMon.Trainer.Pokemon

  # Definir a PK porque optamos por criar uma PK de UUID ( não aceitamos o padrão int autoincrementado)
  @primary_key {:id, Ecto.UUID, autogenerate: true}

  # O mesmo que está em PROJ/priv/repo/migrations/
  schema "trainers" do
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    # Em lib/ex_mon/trainer/pokemon.ex só funciona o belongs_to(:trainers, Trainer) se estiver explicitado o tipo de relacionamento
    # Os parâmetros do has_many(nome_do_esquema, módulo)
    has_many(:pokemon, Pokemon)
    timestamps()
  end

  # As validações através de changesets, que são "Structs Tunadas"
  # Veja mais validações em: https://hexdocs.pm/ecto/Ecto.html#module-changesets
  @required_params [:name, :password]

  # Refatorado para fazer as validações sem ter que ir até o database para obter o erro 
  def build(params) do
    params
    |> changeset()
    # Passando o resultado de changeset e o atom :insert (poderia ser qualquer atom)
    # A função apply_action recebe obrigatoriamente um changeset
    |> apply_action(:insert)
  end

  # Quando passa o parâmetro %__MODULE__{} é porque não será usado em UPDATE 
  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  # Quando passa trainer é porque temos que saber qual é o trainer que deverá sofrer a alteração
  def changeset(trainer, params), do: create_changeset(trainer, params)

  defp create_changeset(module_or_trainer, params) do
    module_or_trainer
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  # Atribui no final para a variável changeset cada nó que interessa para verificar
  # É a mesma coisa que: ExMon.Trainer.changeset(params) que rodamso no Terminal
  # antes de encriptar
  # Primeiro: testamos se vem com o valid = true

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  # Segundo: se chegou aqui é porque o valid DIFERENTE de true
  # Aí então retorna somente o changeset com a apresentação do erro
  defp put_pass_hash(changeset), do: changeset
end
