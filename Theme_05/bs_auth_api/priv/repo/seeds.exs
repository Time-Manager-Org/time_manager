# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BsAuthApi.Repo.insert!(%BsAuthApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias BsAuthApi.Repo
alias BsAuthApi.Accounts.Role

Repo.insert!(%Role{label: "Manager"})
Repo.insert!(%Role{label: "User"})
