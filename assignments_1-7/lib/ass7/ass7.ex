defmodule Ass7 do
  @moduledoc """
  Documentation for `Ass7`.
  """

  @doc """
      ## Teacher's instructions for the assignment:
        Copy the source code to Moodle return box. Alternatively you can paste a link to GitLab. If using GitLab, verify that you have added at least a Reporter permission for the lecturer.

        Implement a game of Blackjack against computer.
          - Create two processes of player and dealer.
          - Use inter-process communication to handle all aspects of the game between player and dealer.
          - No need to implement betting, each game results of win or loss for the player.
          - No need to implement hidden cards, assume that player and dealer cards are visible.
          - Allow option to play again.

      ## Examples
        user@localhost:~/M2296/elixir-programming/assignments_1-7$ iex -S mix
        Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

        Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
        iex(1)> Ass7.ass7_mainloop
        "Starting a new blackjack game! Dealer will now begin by dealing cards. Happy gaming!"
        Dealer dealt 5 of hearts to  Player!
        Dealer dealt 2 of clubs to  Dealer!
        Dealer dealt 10 of diamonds to  Player!
        Dealer dealt 9 of clubs to  Dealer!

        Dealer now has: 2 of clubs, 9 of clubs.
        You now have: 5 of hearts, 10 of diamonds.
        Would you like to get another card (y/n)? y
        Dealer dealt an ace of diamonds to  Player!
        You now have: 5 of hearts, 10 of diamonds, an ace of diamonds.
        Would you like to get another card (y/n)? y
        Dealer dealt 3 of clubs to  Player!
        You now have: 5 of hearts, 10 of diamonds, an ace of diamonds, 3 of clubs.
        Would you like to get another card (y/n)? n
        Dealer dealt 8 of spades to  Dealer!

        Dealer has: 2 of clubs, 9 of clubs, 8 of spades.
        You have: 5 of hearts, 10 of diamonds, an ace of diamonds, 3 of clubs.
        Game finished! You have 19 and Dealer has 19! You lose as per the rules!
        Do you want to start a new game (y/n)? y
        Dealer dealt 7 of clubs to  Player!
        Dealer dealt 8 of hearts to  Dealer!
        Dealer dealt a king of clubs to  Player!
        Dealer dealt 4 of clubs to  Dealer!

        Dealer now has: 8 of hearts, 4 of clubs.
        You now have: 7 of clubs, a king of clubs.
        Would you like to get another card (y/n)? n
        Dealer dealt 5 of diamonds to  Dealer!

        Dealer has: 8 of hearts, 4 of clubs, 5 of diamonds.
        You have: 7 of clubs, a king of clubs.
        Game finished! You have 17 and Dealer has 17! You lose as per the rules!
        Do you want to start a new game (y/n)? y
        Dealer dealt 10 of hearts to  Player!
        Dealer dealt 9 of spades to  Dealer!
        Dealer dealt 8 of clubs to  Player!
        Dealer dealt a jack of spades to  Dealer!

        Dealer now has: 9 of spades, a jack of spades.
        You now have: 10 of hearts, 8 of clubs.
        Would you like to get another card (y/n)? n

        Dealer has: 9 of spades, a jack of spades.
        You have: 10 of hearts, 8 of clubs.
        Game finished! Dealer wins with 19 over your 18. You lose!
        Do you want to start a new game (y/n)? y
        Dealer dealt an ace of spades to  Player!
        Dealer dealt an ace of hearts to  Dealer!
        Dealer dealt a queen of diamonds to  Player!
        Dealer dealt 7 of spades to  Dealer!

        Dealer now has: an ace of hearts, 7 of spades.
        You now have: an ace of spades, a queen of diamonds.
        Would you like to get another card (y/n)? n

        Dealer has: an ace of hearts, 7 of spades.
        You have: an ace of spades, a queen of diamonds.
        Game finished! You got a blackjack! You win!
        Do you want to start a new game (y/n)? n
        Game has now finished! Thank you for playing with us!
        iex(2)>

  """
  def ass7_mainloop do
    import Player
    import Dealer
    Dealer.new()
    Player.new()
    Player.begin()
    "Starting a new blackjack game! Dealer will now begin by dealing cards. Happy gaming!"
  end
end
