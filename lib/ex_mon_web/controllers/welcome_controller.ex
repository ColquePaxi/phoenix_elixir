defmodule ExMonWeb.WelcomeController do
  use ExMonWeb, :controller

  # Toda action no Phx espera 2 parâmetros: a conexão e parâmetros de payload
  # Como não vamos receber parâmetros, colcoa underline para passar qualquer coisa
  def index(conn, _params) do
    # Ver o conteúdo de conn: podemos ler e usar esses conteúdos
    IO.inspect(conn)
    text(conn, "Welcome to the API!")
  end
end
