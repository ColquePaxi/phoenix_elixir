defmodule ExMon.Pokemon do
  @keys [:id, :name, :weight, :types]

  @enforce_keys @keys

  # Tem que usar para o lib/ex_mon_web/controllers/pokemons_controller.ex poder usar 
  # o |> json(pokemon)
  @derive Jason.Encoder
  defstruct @keys

  # No atributo types temos uma LISTA que vem do JSON. Não vamos usar tudo que vem nessa lista,
  # vamos querer pegar somente type.name
  def build(%{"id" => id, "name" => name, "weight" => weight, "types" => types}) do
    # Retorna uma Struct já no padrão que a gente vai manipular.
    # Por exemplo: detro de types[name, url], mas só vamos usar o name
    %__MODULE__{
      id: id,
      name: name,
      weight: weight,
      types: parse_types(types)
    }
  end

  # Lendo a lista types e devolvendo somente type.name
  defp parse_types(types), do: Enum.map(types, fn item -> item["type"]["name"] end)
end
