defmodule ExMonWeb.PokemonsController do
  use ExMonWeb, :controller

  # Será um arquivo de fallback para centraliar todos os erros
  # Isso é uma boa prática
  action_fallback ExMonWeb.FallbackController

  def show(conn, %{"name" => name}) do
    name
    |> ExMon.fetch_pokemon()
    # status-code 200
    |> handle_response(conn)
  end

  defp handle_response({:ok, pokemon}, conn) do
    conn
    # status-code 200
    |> put_status(:ok)
    # Só use json se o retorno for passível de ser encodado como json.
    # Uma Struct NAO PODE ser encodado para Json!!!!
    # Então adicionamos @derive Json.Encoder em lib/ex_mon/pokemon.ex 
    # e temos que garantir que usamos as deps json e tesla para trabalharem juntos nisso
    |> json(pokemon)
  end

  defp handle_response({:error, _reason} = error, _conn), do: error
end
