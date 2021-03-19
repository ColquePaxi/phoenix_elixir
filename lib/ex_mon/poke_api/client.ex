defmodule ExMon.PokeApi.Client do
  use Tesla

  # Um middlewae serve tanto para o resquest quanto para o response
  # No caso do JSON faz: decode, encode tanto na entrada como na saída, e também quando interage com Maps
  plug Tesla.Middleware.BaseUrl, "https://pokeapi.co/api/v2/"
  plug Tesla.Middleware.JSON

  def get_pokemon(name) do
    "/pokemon/#{name}"
    |> get()
    |> handle_get()
  end

  # Esse Pattern Matching que usamos aqui vem do retorno do teste
  # $ alias ExMon.PokeApi.Client
  # $ Client.get_pokemon("pikachu")   # Desabilitando a handle_get() da função get_pokemon()
  # Na struct devolvida tem %Tesla.Env{} e dentro dela os atributos status: e body: 
  defp handle_get({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle_get({:ok, %Tesla.Env{status: 404}}), do: {:error, "Pokemon not found!"}
  # Nesse caso aqui é se der um 500 ou timeout ou qualquer outro diferente dos demais acima
  defp handle_get({:error, _reason} = error), do: error
end
