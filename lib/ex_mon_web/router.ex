defmodule ExMonWeb.Router do
  use ExMonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExMonWeb do
    pipe_through :api
    # Esse é o nome do arquivo em lib/ex_mon_web/controllers/trainers_controller.ex
    # Assim gera TODAS as rotas padrão do Restful, 
    # resources "/trainers", TrainersController
    # Mas como só queremos essas (POST, GET, PUT, DELETE), vamos parametrizar assim: 
    resources "/trainers", TrainersController, only: [:create, :show, :update, :delete]

    resources "/trainer_pokemons", TrainerPokemonsController,
      only: [:create, :show, :update, :delete]

    # Com é só uma rota de get e não vamos usar o resources, então tem que explicitar a action
    # :show (que foi criada em pokemons_controller.ex)
    # Use o mesmo nome de parâmetro que foi usado em pokemons_controller.ex
    get "/pokemons/:name", PokemonsController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ExMonWeb.Telemetry
    end
  end

  # Implenentação de rota
  scope "/", ExMonWeb do
    pipe_through :api
    get "/", WelcomeController, :index
  end
end
