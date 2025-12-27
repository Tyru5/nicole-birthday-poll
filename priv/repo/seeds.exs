# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Poll.Repo.insert!(%Poll.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Poll.Repo
alias Poll.Polls.{Poll, Option}

# Create a sample poll with 2 options
poll =
  Repo.insert!(%Poll{
    title: "When should we go bowling for Nicole's birthday? 🎉",
    description:
      "It's going to be on January 3rd, however, I was bored so I implemented this realtime voting page in the Phoenix web framework 😎"
  })

Repo.insert!(%Option{
  text: "December 27th",
  poll_id: poll.id
})

Repo.insert!(%Option{
  text: "January 3rd",
  poll_id: poll.id
})
