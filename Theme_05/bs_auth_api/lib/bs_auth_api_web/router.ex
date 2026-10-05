defmodule BsAuthApiWeb.Router do
  use BsAuthApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug BsAuthApiWeb.Plugs.AuthPlug
  end

  scope "/api", BsAuthApiWeb do
    pipe_through :api

    # Unauthenticated Public Routes
    scope "/users" do
      post "/sign_up", UserController, :sign_up
      post "/sign_in", AuthController, :sign_in
    end

    # Authenticated Protected Routes
    scope "/" do
      pipe_through :authenticated

      # to get profile of current user
      get "/profile", AuthController, :profile

      # Sign Out requires authentication context
      post "/users/sign_out", AuthController, :sign_out

      # Skills
      get "/skills", SkillController, :index
      get "/users/:id/skills", SkillController, :user_skills
      post "/users/:userid/skills", SkillController, :add_user_skill_by_name
      post "/users/:userid/skills/:skillid", SkillController, :add_user_skill
      delete "/users/:userid/skills/:skillid", SkillController, :remove_user_skill

      # Tasks
      resources "/tasks", TaskController, except: [:new, :edit]
      put "/tasks/:taskid/skills/:skillid", TaskController, :assign_skill
      post "/tasks/:taskid/user/:userid", TaskController, :assign_user
      delete "/tasks/:taskid/user/:userid", TaskController, :remove_user
      put "/tasks/:taskid/status", TaskController, :toggle_status
    end
  end

  # Development Routes
  if Application.compile_env(:bs_auth_api, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BsAuthApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
