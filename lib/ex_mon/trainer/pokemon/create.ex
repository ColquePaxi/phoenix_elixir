defmodule ExMon.Trainer.Pokemon.Create do
  alias ExMon.Pokemon
  alias ExMon.Trainer.Pokemon, as: TrainerPokemon
  alias ExMon.PokeApi.Client
  alias ExMon.Repo

  def call(%{"name" => name} = params) do
    name
    |> Client.get_pokemon()
    |> handle_response(params)
  end

  # Pokemon.build() foi criada para fazer o parse do que o Client.get_pokemon() retorna
  defp handle_response({:ok, body}, params) do
    body
    |> Pokemon.build()
    |> create_pokemon(params)
  end

  # Se der erro, a gente empurra o erro porque o FallbackController já resolve os erros
  defp handle_response({:error, _reason} = error, _params), do: error

  # lib/ex_mon/pokemon.ex -> build() retorna a struct  
  # %__MODULE__{
  #    id: id,
  #    name: name,
  #    weight: weight,
  #    types: parse_types(types)
  #  }
  # Então use-a para fazer pattern matching
  # E da variável params (o que o usuário infroma), pegamos "nickname" => nickname, "trainer_id" => trainer_id
  # Nâo se pega os FK porque são gerados automaticamente 
  defp create_pokemon(%Pokemon{name: name, weight: weight, types: types}, %{
         "nickname" => nickname,
         "trainer_id" => trainer_id
       }) do
    # Agora junta as 2 structs numa só 
    params = %{
      # Informe ao criar o Pokemon
      name: name,
      # Retorno da API
      weight: weight,
      # Retorno da API
      types: types,
      # Informe ao criar o Pokemon
      nickname: nickname,
      # Informe ao criar o Pokemon
      trainer_id: trainer_id
    }

    # Pega os params buildados (as 2 structs juntas)
    params
    |> TrainerPokemon.build()
    |> handle_build()
  end

  defp handle_build({:ok, pokemon}), do: Repo.insert(pokemon)
  # Empurra o erro para o FallbackController gerenciar
  defp handle_build({:error, _changeset} = error), do: error
end
