defmodule ExMon.Pokemon.Get do
  # Para usar o client http do tesla de lib/ex_mon/poke_api/client.ex
  alias ExMon.PokeApi.Client
  # Para usar a Struct Pokemon do lib/ex_mon/pokemon.ex
  alias ExMon.Pokemon

  def call(name) do
    name
    |> Client.get_pokemon()
    |> handle_response()
  end

  # Pokemon.build() foi criada para fazer o parse do que o Client.get_pokemon() retorna
  defp handle_response({:ok, body}), do: {:ok, Pokemon.build(body)}
  # Se der erro, a gente empurra o erro porque o FallbackController já resolve os erros
  defp handle_response({:error, _reason} = error), do: error
end
