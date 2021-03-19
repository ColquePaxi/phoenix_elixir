defmodule ExMonWeb.TrainerPokemonsController do
  use ExMonWeb, :controller

  # Será um arquivo de fallback para centraliar todos os erros
  # Isso é uma boa prática
  action_fallback ExMonWeb.FallbackController

  # Essa função dentro do controller é conhecida como ACTION
  def create(conn, params) do
    params
    # Chamando aquela função que colocamos na FACHADA
    |> ExMon.create_trainer_pokemon()
    # Manipular o retorno dessa tentativa de gravar no database
    # status-code 201
    |> handle_response(conn, "create.json", :created)
  end

  # Refatorado para receber view e status a fim de usar tanto para create quanto para show
  defp handle_response({:ok, pokemon}, conn, view, status) do
    conn
    # No Phx tem atoms que representam os códigos http
    # Procure: phoenix http status
    # Veja em https://hexdocs.pm/plug/Plug.Conn.Status.html
    # Poderia ser: put_status(200)
    # put_status(:ok)
    |> put_status(status)
    # Renderizar uma VIEW (forma amigável de dar retorno ao client) e no 2o parâmetro passar o que 
    # se quer renderizar
    # render() é uma função que tem que ser criada lá em lib/ex_mon_web/views/trainers_view.ex 
    # Esse << create_json >> tem que ser definido lá também
    |> render(view, pokemon: pokemon)
  end

  # Só que vamos tratar via Fallback Centralizado
  # Foi criado lá em cima a action de fallback 
  # Como refatorou com view e status, tem que usar aqui tb (como Underline porque não terá serventia) 
  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error

  # Estamos usando a NOTAÇÃO como se fosse um JSON do Postman passando {"id": id}
  def delete(conn, %{"id" => id}) do
    id
    |> ExMon.delete_trainer_pokemon()
    |> handle_delete(conn)
  end

  # Não devolve nada. O status-code é suficiente para saber se realizou ou não a deleção
  # Como não vou usar dados do pokemon então uso variável com
  # Vc pode criar um handle_response, criar uma view de delete e mostrar para o usuário 
  # os dados pokemon da ação delete. É opcional. 
  defp handle_delete({:ok, _pokemon}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  # Empurra o erro para o Fallback Controller
  defp handle_delete({:error, _reason} = error, _conn), do: error

  def show(conn, %{"id" => id}) do
    id
    |> ExMon.fetch_trainer_pokemon()
    # status-code 200
    |> handle_response(conn, "show.json", :ok)
  end

  def update(conn, params) do
    params
    # Chamando aquela função que colocamos na FACHADA
    |> ExMon.update_trainer_pokemon()
    # Manipular o retorno dessa tentativa de gravar no database
    # status-code 200
    |> handle_response(conn, "update.json", :ok)
  end
end
