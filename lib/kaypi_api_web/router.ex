defmodule KaypiApiWeb.Router do
  use KaypiApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "text/xml"]
  end

  pipeline :api_auth do
    plug KaypiApi.Pipeline.Auth
  end

  scope "/", KaypiApiWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/demo-llamar", TwilioController, :demo_llamar
    get "/demo-recibir", TwilioController, :demo_recibir
  end

  # Other scopes may use custom stacks.
  scope "/api", KaypiApiWeb do
    pipe_through :api

    resources "/user_types", UserTypeController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/credentials", CredentialController, except: [:new, :edit]
    post "/session", SessionController, :create

    post "/dial", TwilioController, :dial


  end

  # Secure API
  scope "/api/secure", KaypiApiWeb do
    pipe_through [:api, :api_auth]

    get "/twilio-token", TwilioController, :token
    get "/receive-token", TwilioController, :receive
    get "/llamar-token", TwilioController, :llamar
  end
end
