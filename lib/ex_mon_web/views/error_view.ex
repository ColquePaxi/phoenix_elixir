defmodule ExMonWeb.ErrorView do
  use ExMonWeb, :view

  import Ecto.Changeset, only: [traverse_errors: 2]

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  # Vamos refatorar porque ao implementar o trainer_delete() deu erro porque tentou 
  # usar o translate_errors() em um retorno de uma mensagem simples (foi preparada
  # para receber changeset em sua versão original)
  # def render("400.json", %{result: result}) do
  #  %{
  #    message: translate_errors(result)
  #  }
  # end

  def render("400.json", %{result: %Ecto.Changeset{} = result}) do
    %{
      message: translate_errors(result)
    }
  end

  def render("400.json", %{result: message}) do
    %{
      message: message
    }
  end

  # Criar uma mensagem amigável ao usuário. O Ecto já tem uma função que faz isso.
  # https://hexdocs.pm/ecto/Ecto.Changeset.html#traverse_errors/2
  defp translate_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
