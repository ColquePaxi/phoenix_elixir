defmodule ExMon.TrainerTest do
  # Usando as ferramentas do Ecto descritas em ex_mon/test/support/data_case.ex
  use ExMon.DataCase

  alias ExMon.Trainer

  describe "changeset/1" do
    test "when all params are valids, returns a valid changeset" do
      params = %{name: "Colque", password: "123456"}

      response = Trainer.changeset(params)

      # :banana == response

      assert %Ecto.Changeset{
               changes: %{
                 name: "Colque",
                 password: "123456"
               },
               errors: [],
               data: %ExMon.Trainer{},
               valid?: true
             } = response
    end
  end

  describe "changeset/2" do
    test "when all params are invalids, returns a invalid changeset" do
      params = %{password: "123456"}

      response = Trainer.changeset(params)

      :banana == response

      '''
      assert %Ecto.Changeset{
               changes: %{
                 name: "Colque",
                 password: "123456"
               },
               errors: [],
               data: %ExMon.Trainer{},
               valid?: true
             } = response
      '''
    end
  end
end
