defmodule Card do
  @enforce_keys [:suit, :value]
  defstruct [:suit, :value]
  @type t :: %__MODULE__{suit: String.t(), value: 1..13}
end

# practically unused module because hidden cards didn't need to be implemented
defmodule DealersCard do
  @enforce_keys [:card, :hidden]
  defstruct [:card, :hidden]
  @type t :: %__MODULE__{card: Card.t(), hidden: boolean()}
end

# a module to resolve names from cards of certain values
defmodule NamedCards do
  defstruct cases: %{1 => "an ace", 11 => "a jack", 12 => "a queen", 13 => "a king"}
end

# a module that contains all the game-specific stuff
defmodule Game do
  import Card
  import NamedCards
  @enforce_keys [:deck, :participants_cards]
  defstruct [:deck, :participants_cards]
  @type t :: %__MODULE__{deck: [Card.t()], participants_cards: [Card.t()]}

  @named_cards %NamedCards{}
  @cards Enum.flat_map(
           ["hearts", "spades", "clubs", "diamonds"],
           fn suit ->
               Enum.map(
                 Enum.to_list(1..13),
                 fn value -> %Card{suit: suit, value: value} end
               )
           end
         )

  def begin do
    deck = Enum.shuffle(@cards)
    players_cards = []
    dealers_cards = []

    %_{deck: deck, participants_cards: players_cards} =
      deal(%Game{deck: deck, participants_cards: players_cards}, "Player")

    %_{deck: deck, participants_cards: dealers_cards} =
      deal(%Game{deck: deck, participants_cards: dealers_cards}, "Dealer")

    %_{deck: deck, participants_cards: players_cards} =
      deal(%Game{deck: deck, participants_cards: players_cards}, "Player")

    %_{deck: deck, participants_cards: dealers_cards} =
      deal(%Game{deck: deck, participants_cards: dealers_cards}, "Dealer")

    [deck, players_cards, dealers_cards]
  end

  @spec check_blackjack(cards :: [Card.t()]) :: boolean()
  def check_blackjack(cards) do
    card_values =
      Enum.flat_map(cards, fn card ->
        [check_value([card], true)]
      end)

    if length(card_values) == 2 && Enum.sum(card_values) == 21 do
      true
    else
      false
    end
  end

  @spec check_value(cards :: [Card.t()], only_highest :: boolean()) ::
          non_neg_integer() | %{total: non_neg_integer(), alt_total: non_neg_integer()}
  def check_value(cards, only_highest \\ false) do
    values =
      Enum.reduce(cards, %{total: 0, alt_total: 0, aces: 0}, fn %Card{value: card_value, suit: _},
                                                                %{
                                                                  total: total_val,
                                                                  alt_total: alt_total_val,
                                                                  aces: aces_val
                                                                } ->
        counted_value = (card_value > 10 && 10) || card_value
        # got an ace... we need to track an "alt_total" because ace can be both 1 or 11
        if card_value == 1 do
          %{total: total_val + 11, alt_total: alt_total_val + 1, aces: aces_val + 1}
        # not an ace
        else
          %{
            total: total_val + counted_value,
            alt_total: alt_total_val + counted_value,
            aces: aces_val
          }
        end
      end)

    # fix bug when in some rare cases a player gets 2 aces and one ace should be counted as 1 and the other as 11 in order to get the best total
    values =
      (values.aces > 1 && values.alt_total + 10 < 22 &&
         %{total: values.total, alt_total: values.alt_total + 10}) ||
        %{total: values.total, alt_total: values.alt_total}

    # if only_highest is set, return the highest total that does not lose, or nil if all totals are losing
    if only_highest do
      (values.total > values.alt_total && values.total < 22 && values.total) ||
        (values.alt_total < 22 && values.alt_total) || nil
    else
      values
    end
  end

  # deals a card from deck into participants_cards and prints what was dealt
  @spec deal(cards :: [Card.t()], owner :: String.t(), hidden :: boolean()) :: Game.t()
  def deal(%Game{deck: game_deck, participants_cards: cards}, owner, hidden \\ false) do
    card = hd(game_deck)
    game_deck = tl(game_deck)
    card_print = get_card_print(card)
    # implementation of hidden cards is unused (and not required by Assignment Instructions)
    msg =
      (!hidden && "Dealer dealt #{card_print} of #{card.suit} to  #{owner}!") ||
        "Dealer dealt a face down card to theirselves!"

    IO.puts(msg)
    :timer.sleep(300)
    %Game{deck: game_deck, participants_cards: List.insert_at(cards, length(cards), card)}
  end

  defp get_card_print(card) do
    card_print = Map.fetch(@named_cards.cases, card.value)
    (is_tuple(card_print) && elem(card_print, tuple_size(card_print) - 1)) || card.value
  end

  # prints all cards the owner has
  @spec print_cards(cards :: [Card.t()], owner_has :: String.t()) :: any()
  def print_cards(cards, owner_has) do
    card_print =
      List.last(
        Enum.reduce(cards, [0, ""], fn card, acc ->
          print = Enum.find(acc, fn elem -> is_bitstring(elem) end)
          count = Enum.find(acc, fn elem -> is_integer(elem) end)
          card_print = get_card_print(card)

          if count + 1 == length(cards) do
            [count + 1, print <> "#{card_print} of #{card.suit}"]
          else
            [count + 1, print <> "#{card_print} of #{card.suit}, "]
          end
        end)
      )

    IO.puts("#{owner_has}: #{card_print}.")
  end
end

defmodule Dealer do
  @enforce_keys [:deck, :dealers_cards, :players_cards]
  defstruct [:deck, :dealers_cards, :players_cards]
  @type t :: %__MODULE__{deck: [Card.t()], dealers_cards: [Card.t()], players_cards: [Card.t()]}
  import Card
  alias Game

  def begin() do
    [deck, players_cards, dealers_cards] = Game.begin()
    IO.puts("")
    Game.print_cards(dealers_cards, "Dealer now has")
    %Dealer{deck: deck, dealers_cards: dealers_cards, players_cards: players_cards}
  end

  defp deal_until_over_16(dealer_state) do
    if(Game.check_value(dealer_state.dealers_cards, true) < 17) do
      %_{deck: deck, participants_cards: dealers_cards} =
        Game.deal(
          %Game{deck: dealer_state.deck, participants_cards: dealer_state.dealers_cards},
          "Dealer"
        )

      deal_until_over_16(%Dealer{
        deck: deck,
        dealers_cards: dealers_cards,
        players_cards: dealer_state.players_cards
      })
    else
      dealer_state
    end
  end

  defp loop(dealer_state) do
    receive do
      {:begin} ->
        dealer_state = begin()
        send(:Player, {:get_card, dealer_state.players_cards})
        loop(dealer_state)

      {:deal} ->
        %_{deck: new_deck, participants_cards: players_cards} =
          Game.deal(
            %Game{deck: dealer_state.deck, participants_cards: dealer_state.players_cards},
            "Player"
          )

        dealer_state = %Dealer{
          deck: new_deck,
          dealers_cards: dealer_state.dealers_cards,
          players_cards: players_cards
        }

        results = Game.check_value(dealer_state.players_cards, true)

        if results == nil do
          %{total: players_total, alt_total: players_alt_total} =
            Game.check_value(dealer_state.players_cards)

          send(
            :Player,
            {:game_finished, dealer_state.players_cards,
             "You lost! (your cards' total is #{(players_total < players_alt_total && players_total) || players_alt_total} which is over 21)"}
          )

          loop(%Dealer{deck: [], dealers_cards: [], players_cards: []})
        else
          send(:Player, {:get_card, dealer_state.players_cards})
          loop(dealer_state)
        end

      {:finished} ->
        dealer_state =
          (Game.check_value(dealer_state.dealers_cards, true) < 17 &&
             deal_until_over_16(dealer_state)) ||
            dealer_state

        Game.print_cards(dealer_state.dealers_cards, "\nDealer has")
        %{total: result, alt_total: alt_result} = Game.check_value(dealer_state.dealers_cards)
        has_lost = result > 21 && alt_result > 21

        players_highest_combination = Game.check_value(dealer_state.players_cards, true)
        dealers_highest_combination = Game.check_value(dealer_state.dealers_cards, true)
        player_has_blackjack = Game.check_blackjack(dealer_state.players_cards)
        dealer_has_blackjack = Game.check_blackjack(dealer_state.dealers_cards)

        cond do
          player_has_blackjack && !dealer_has_blackjack ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards, "You got a blackjack! You win!"}
            )

          player_has_blackjack && dealer_has_blackjack ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "You both got a blackjack and it's a stand-off! The result is a tie!"}
            )

          dealer_has_blackjack ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "Dealer has a blackjack and you don't! You lose!"}
            )

          has_lost ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "Dealer has drawn over 21 (#{(result < alt_result && result) || alt_result}) so they lose! You are the winner!"}
            )

          dealers_highest_combination > players_highest_combination ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "Dealer wins with #{dealers_highest_combination} over your #{players_highest_combination}. You lose!"}
            )

          dealers_highest_combination == players_highest_combination &&
              players_highest_combination == 21 ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "You both have 21, the result is a tie!"}
            )

          dealers_highest_combination == players_highest_combination ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "You have #{players_highest_combination} and Dealer has #{dealers_highest_combination}! You lose as per the rules!"}
            )

          true ->
            send(
              :Player,
              {:game_finished, dealer_state.players_cards,
               "You win with #{players_highest_combination} over Dealer's #{dealers_highest_combination}!"}
            )
        end

        loop(%Dealer{deck: [], players_cards: [], dealers_cards: []})

      {:quit} ->
        send(:Player, {:ok})
    end
  end

  def new do
    pid = spawn(fn -> loop(%Dealer{deck: [], dealers_cards: [], players_cards: []}) end)
    Process.register(pid, :Dealer)
  end
end

defmodule Player do
  defstruct [:your_cards]
  @type t :: %__MODULE__{your_cards: [Card.t()]}

  def ask_continue(query) do
    input = IO.gets(query)
    case String.trim_trailing(input, "\n") do
      "y" -> true
      "n" -> false
      _ -> ask_continue("Wrong option! pick either 'y' or 'n': ")
    end

  end
  def begin() do
    send(:Player, {:begin})
  end

  defp loop(_state) do
    alias Game

    receive do
      {:begin} ->
        :timer.sleep(1750)
        send(:Dealer, {:begin})
        loop(%Player{your_cards: []})
      # print results, new game, cleans state
      {:game_finished, cards, status} ->
        (length(cards) > 0 && Game.print_cards(cards, "You have")) || nil

        answer = ask_continue("Game finished! #{status} \nDo you want to start a new game (y/n)? ")

        case answer do
          true ->
            send(:Dealer, {:begin})
            loop(%Player{your_cards: []})
          false ->
            send(:Dealer, {:quit})
            loop(%Player{your_cards: []})
        end

      # receives card, updates state
      {:get_card, cards} ->
        Game.print_cards(cards, "You now have")
        answer = ask_continue("Would you like to get another card (y/n)? ")
        case answer do
          true -> send(:Dealer, {:deal})
          false -> send(:Dealer, {:finished})
        end

        loop(%Player{your_cards: cards})

      # Dealer process has exited, now we can quit as well
      {:ok} ->
        IO.puts("Game has now finished! Thank you for playing with us!")
    end
  end

  def new do
    pid = spawn(fn -> loop(%Player{your_cards: []}) end)
    Process.register(pid, :Player)
  end
end
