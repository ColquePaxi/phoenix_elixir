defmodule ExMonWeb.FallbackController do
  use ExMonWeb, :controller

  # Toda fallback obrogatoriamente tem que ter uma função call() alinhada ao que é enviado 
  # em defp handle_response de fallback_controller.ex 
  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    # Como tem que renderizar uma View com um NOme Diferente do Cotnroller, então tem que usar put_view()
    |> put_view(ExMonWeb.ErrorView)
    # Esse render vai ser criado em lib/ex_mon_web/view/error_view.ex
    |> render("400.json", result: result)
  end
end
