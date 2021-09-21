defmodule Ass4 do
  @moduledoc """
  Documentation for `Ass4`.
  """

  @doc """
  ## Teacher's instructions for Part 1:

    Declare a keyword list that contains name of the color and color html value.
      * See html color values here: https://www.w3schools.com/colors/colors_names.asp
      * Add at least 10 colors to the keyword list


    Create a loop that asks user the color name or color html value.
      * If entered text begins with '#', print the corresponding color name.
      * Otherwise print the corresponding html color value.
      * If neither is found in keyword list, exit the loop.

 

  ## Teacher's instructions for Part 2

    Declare a map that contains book ISBN as a key and book name as a value.
      * Add at least 5 books into the map


    Create a loop that reads commands from the user:
      * list lists all books in the map.
      * search ISBN searches a book with specified ISBN and prints book info.
      * add ISBN,NAME adds new book into the map.
      * remove ISBN removes book with ISBN if found on map.
      * quit exits the loop.

  ## Examples

    user@localhost:~/M2296/elixir-programming/assignments$ elixir lib/ass4.exs


    user@localhost:~/M2296/elixir-programming/assignments$


"""

  def part1 do
    IO.puts("=== PART 1 ===")

    colors = [
      "Tan": "#D2B48C",
      "Teal": "#008080",
      "Thistle": "#D8BFD8",
      "Tomato": "#FF6347",
      "Turquoise": "#40E0D0",
      "Violet": "#EE82EE",
      "Wheat": "#F5DEB3",
      "White": "#FFFFFF",
      "WhiteSmoke": "#F5F5F5",
      "Yellow": "#FFFF00"
    ]

    # parameters for mainloop anonymous function:
    #   * main func to return to (it itself - to achieve recursion)
    #   * resolve color func that the main function will call
    mainloop =
    fn (resolve_color_func, main_func) ->
      result = resolve_color_func.(
        String.trim_trailing(IO.gets("Give a color or a HTML color code: "), "\n"))
      if result, do: main_func.(resolve_color_func, main_func)
    end

    # parameters for resolve color anonymous function:
    #   * color to resolve against the colors list
    resolve_color =
    fn (color) ->
      cond do
      String.slice(color, 0, 1) == "#"  ->
        found = Enum.find_value(colors, fn {color_key, color_value} ->  if to_string(color_value) == color, do: color_key, else: false end)
        if found do
          IO.puts "Found color name of #{found}"
          true
        else
          IO.puts "No color names or color codes found with the specified query.\nExiting..."
          false
        end
      true ->  found = Enum.find_value(
        colors, fn {color_key, color_value} ->  if to_string(color_key) == color, do: color_value, else: false end)
        if found do
          IO.puts "Found color value of #{found}"
          true
        else
          IO.puts "No color names or color codes found with the specified query.\nExiting..."
          false
        end
      end
    end

    # use either one of these
    mainloop.(resolve_color, mainloop)
    # Ass4.part1_mainloop(colors);


    IO.puts "== FINISHED ==\n"
  end

  def part2 do
    IO.puts("=== PART 2 ===")

    IO.puts "== FINISHED ==\n"

  end

  # alternative way to do part 1 (comprised of the next 2 functions) is below
  # these are basically unused because I managed to do the same with anonymous functions
  # I disliked passing around the colors list (like you see below) all the time so I wanted to get rid of that
  # Now I'm passing around functions, and I guess that at least it is more appropriate for this course titled 'functional programming', if nothing else...
  def part1_mainloop(colors) do
   Ass4.part1_resolve_color(colors, String.trim_trailing(IO.gets("Give a color or a HTML color value: "), "\n"))
  end

  def part1_resolve_color(colors, color) do
    cond do
      String.slice(color, 0, 1) == "#"  ->
        found = Enum.find_value(colors, fn {color_key, color_value} ->  if to_string(color_value) == color, do: color_key, else: false end)
        if found do
          IO.puts "Found color name of #{found}"
          Ass4.part1_mainloop(colors)
        else IO.puts "No colors or color codes found with the specified query.\nExiting..."
      end
      true ->  found = Enum.find_value(
        colors, fn {color_key, color_value} ->  if to_string(color_key) == color, do: color_value, else: false end)
        if found do
          IO.puts "Found color value of #{found}"
          Ass4.part1_mainloop(colors)
        else IO.puts "No colors or color codes found with the specified query.\nExiting..."
      end
    end

  end

end

Ass4.part1()
# Ass4.part2()
