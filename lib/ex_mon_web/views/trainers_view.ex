defmodule ExMonWeb.TrainersView do
  use ExMonWeb, :view

  # Faz link com lib/ex_mon_web/controllers/trainers_controller.ex e com o que está sendo 
  # passado de parâmetros lá.
  # Nesse caso, uma string e um Map (com uma chave/valor >>> trainer: trainer)  
  # Poderia ser informando variavel.atributo do schema assim:
  # def render("create.json", %{trainer: trainer}) do
  #  %{
  #    message: "Trainer has been created!",
  #    trainer: %{
  #      id: trainer.id,
  #      name: trainer.name,
  #      inserted_at: trainer.inserted_at
  #    }
  #  }
  # end

  # Ou usando o padrão Pattern Matching assim:
  alias ExMon.Trainer

  def render("create.json", %{trainer: %Trainer{id: id, name: name, inserted_at: inserted_at}}) do
    %{
      message: "Trainer has been created!",
      trainer: %{
        id: id,
        name: name,
        inserted_at: inserted_at
      }
    }
  end

  def render("show.json", %{trainer: %Trainer{id: id, name: name, inserted_at: inserted_at}}) do
    %{
      trainer: %{
        id: id,
        name: name,
        inserted_at: inserted_at
      }
    }
  end

  def render("update.json", %{
        trainer: %Trainer{id: id, name: name, inserted_at: inserted_at, updated_at: updated_at}
      }) do
    %{
      message: "Trainer has been updated!",
      trainer: %{
        id: id,
        name: name,
        inserted_at: inserted_at,
        updated_at: updated_at
      }
    }
  end
end
