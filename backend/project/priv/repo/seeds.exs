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


# Main admin that will promote users to manager or admin; no other way to add admins/managers right now.
TimeManager.Repo.insert!(%TimeManager.Accounts.User{
  username: "admin",
  full_name: "Admin User",
  email: "admin@company.com",
  password_hash: Bcrypt.hash_pwd_salt("admin123"),   # Change password
  role: :admin
})


# Demo Manager just for testing
TimeManager.Repo.insert!(%TimeManager.Accounts.User{
  username: "test_manager",
  full_name: "Test Manager",
  email: "manager@company.com",
  password_hash: Bcrypt.hash_pwd_salt("manager123"),    # Remove or change password
  role: :manager
})
