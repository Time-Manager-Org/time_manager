# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


# Local demo accounts. Seed only when the username is absent so this script can
# be rerun without creating duplicate accounts or resetting existing passwords.
unless TimeManager.Repo.get_by(TimeManager.Accounts.User, username: "admin") do
  TimeManager.Repo.insert!(%TimeManager.Accounts.User{
    username: "admin",
    full_name: "Admin User",
    email: "admin@company.com",
    password_hash: Bcrypt.hash_pwd_salt("admin123"),
    role: :admin
  })
end

unless TimeManager.Repo.get_by(TimeManager.Accounts.User, username: "test_manager") do
  TimeManager.Repo.insert!(%TimeManager.Accounts.User{
    username: "test_manager",
    full_name: "Test Manager",
    email: "manager@company.com",
    password_hash: Bcrypt.hash_pwd_salt("manager123"),
    role: :manager
  })
end
