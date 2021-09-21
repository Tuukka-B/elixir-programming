defmodule Ass2 do
  @moduledoc """
  Documentation for `Ass1`.
  """

  @doc """
  ## Teacher's instructions for Part 1:

    Write an Elixir script that calculates how many words are in string "99 bottles of beer on the wall".

  ## Teacher's instructions for Part 2:

    Given a phrase "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment"., translate it a word at a time to Pig Latin.
    Words beginning with consonants should have the consonant moved to the end of the word, followed by "ay".
    Words beginning with vowels (aeiou) should have "ay" added to the end of the word.
    Some groups of letters are treated like consonants, including "ch", "qu", "squ", "th", "thr", and "sch".
    Some groups are treated like vowels, including "yt" and "xr".

  ## Examples
    user@localhost:~/M2296/elixir-programming/assignments$ elixir lib/ass2.exs
    === PART 1 ===
    Word count for a sentence "99 bottles of beer on the wall" is 7.
    == FINISHED ==
    === PART 2 ===
    "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment" converted to pig latin is
    "Atternpay Atchingmay ithway Elixiray. Ememberray atthay equalsay ignsay isay aay atchmay operatoray, otnay anay assignmentay"
    == FINISHED ==


  """
  def part1 do
    IO.puts("=== PART 1 ===")

    base_string = "99 bottles of beer on the wall"
    IO.puts "Word count for a sentence \"#{base_string}\" is #{length(String.split(base_string))}."

    IO.puts "== FINISHED ==\n"
  end

  def part2 do
    IO.puts("=== PART 2 ===")
    base_string = "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment"
    word_list = String.split(base_string)
    words = Enum.map(word_list, fn word -> Ass2.convert_to_pig_latin(word) end)

    IO.puts "\"#{base_string}\" converted to pig latin is \n\"#{Enum.join(words, " ")}\""
    IO.puts "== FINISHED ==\n"

  end

  def convert_to_pig_latin(word) do

    cond do

      # check if a word contains comma or dot or other special characters so we know to preserve them
      # recursion accomplishes this nicely
      String.match?(String.downcase(word), ~r/\W$/) ->
        Ass2.convert_to_pig_latin(String.slice(word, 0, String.length(word) - 1)) <> String.slice(word, String.length(word) -1, 1)

      # check for rare cases when beginning three letters of a word are counted as one syllable
      # (not an extensive check)
      String.match?(String.downcase(word), ~r/^(squ)|(thr)|(str)/) ->
        result = String.slice(word, 3, String.length(word) - 1) <> String.slice(String.downcase(word), 0, 3) <> "ay"
        Ass2.preserve_upcase(word, result)

      # check for cases when beginning two letters of a word are counted as one syllable
      # (not an extensive check)
      String.match?(String.downcase(word), ~r/^((ch)|(qu)|(squ)|(th)|(thr)|(sch)|(sm)|(str)|(st)|(gl)|(tr)|(fl)|(st))/) ->
        result = String.slice(String.downcase(word), 2, String.length(word) - 1) <> String.slice(String.downcase(word), 0, 2) <> "ay"
        Ass2.preserve_upcase(word, result)

      # check for some vowel special cases
      # (not an extensive check)
      String.match?(String.downcase(word), ~r/^(yt)|(xr)/) ->
        word <> "ay"

      # handle everything else (=common cases) separately
      true ->
        cond do

          # begins with a consonant
          String.match?(String.downcase(word), ~r/^[bcdfghjklmnpqrstvwxz]/)->
            result = String.slice(String.downcase(word), 1, String.length(word) - 1) <> String.slice(String.downcase(word), 0, 1) <> "ay"
            Ass2.preserve_upcase(word, result)

          # begins with a vowel
          String.match?(String.downcase(word), ~r/^[aeiouy]/) ->
            word <> "ay"

          # something went wrong if the following condition triggers
          # (or maybe the word began with a special letter or a number not included in the regular expression checks)
          true -> word <> "ay"
        end
      end
  end

  def convert_to_pig_latin() do
    nil
 end

 def preserve_upcase(original_word, resulting_word) do
   cond do
     String.upcase(String.slice(original_word, 0, 1)) ==
     String.slice(original_word, 0, 1) ->
      String.upcase(String.slice(resulting_word, 0, 1)) <>
      String.slice(resulting_word, 1, String.length(resulting_word) - 1)
     true -> resulting_word
   end
 end
end

Ass2.part1()
Ass2.part2()
