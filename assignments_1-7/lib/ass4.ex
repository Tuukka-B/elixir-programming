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

      user@localhost:~/M2296/elixir-programming/assignments_1-7$ iex -S mix
      iex(1)> Ass4.ass4_mainloop
      === PART 1 ===
      Give a color or a HTML color code: Tan
      Found color value of #D2B48C
      Give a color or a HTML color code: Yellow
      Found color value of #FFFF00
      Give a color or a HTML color code: #D2B48C
      Found color name of Tan
      Give a color or a HTML color code: Blue
      No color names or color codes found with the specified query.
      Exiting...
      == FINISHED ==

      === PART 2 ===
      Choose an action from: list, search, add, remove, quit: list

      ISBN: 9780007203543, title: Fellowship of the Ring, J.R.R. Tolkien
      ISBN: 9780007203550, title: Two Towers, J.R.R. Tolkien
      ISBN: 9780007203567, title: Return of the King, J.R.R. Tolkien
      ISBN: 9780132542883, title: Clean Coder, The, Robert C. Martin
      ISBN: 9780136083252, title: Clean Code, Robert C. Martin

      Choose an action from: list, search, add, remove, quit: search
      Enter ISBN to search for: 9780132542883

      Match found!
      ISBN: 9780132542883, title: Clean Coder, The, Robert C. Martin

      Choose an action from: list, search, add, remove, quit: add
      Enter ISBN for new book: 9780132542880
      Enter title with author for new book: Three Towers, R.J.J. Tolkien
      All done!

      Choose an action from: list, search, add, remove, quit: list

      ISBN: 9780007203543, title: Fellowship of the Ring, J.R.R. Tolkien
      ISBN: 9780007203550, title: Two Towers, J.R.R. Tolkien
      ISBN: 9780007203567, title: Return of the King, J.R.R. Tolkien
      ISBN: 9780132542880, title: Three Towers, R.J.J. Tolkien
      ISBN: 9780132542883, title: Clean Coder, The, Robert C. Martin
      ISBN: 9780136083252, title: Clean Code, Robert C. Martin

      Choose an action from: list, search, add, remove, quit: remove
      Enter ISBN of a book to be removed: 9780132542883
      All done!

      Choose an action from: list, search, add, remove, quit: list

      ISBN: 9780007203543, title: Fellowship of the Ring, J.R.R. Tolkien
      ISBN: 9780007203550, title: Two Towers, J.R.R. Tolkien
      ISBN: 9780007203567, title: Return of the King, J.R.R. Tolkien
      ISBN: 9780132542880, title: Three Towers, R.J.J. Tolkien
      ISBN: 9780136083252, title: Clean Code, Robert C. Martin

      Choose an action from: list, search, add, remove, quit: quit
      Byebye!
      == FINISHED ==

      user@localhost:~/M2296/elixir-programming/assignments$


  """

  def part1 do
    IO.puts("=== PART 1 ===")

    colors = [
      Tan: "#D2B48C",
      Teal: "#008080",
      Thistle: "#D8BFD8",
      Tomato: "#FF6347",
      Turquoise: "#40E0D0",
      Violet: "#EE82EE",
      Wheat: "#F5DEB3",
      White: "#FFFFFF",
      WhiteSmoke: "#F5F5F5",
      Yellow: "#FFFF00"
    ]

    # parameters for mainloop anonymous function:
    #   * main func to return to (it itself - to achieve recursion)
    #   * resolve color func that the main function will call
    mainloop = fn resolve_color_func, main_func ->
      result =
        resolve_color_func.(
          String.trim_trailing(IO.gets("Give a color or a HTML color code: "), "\n")
        )

      if result, do: main_func.(resolve_color_func, main_func)
    end

    # parameters for resolve color anonymous function:
    #   * color to resolve against the colors list
    resolve_color = fn color ->
      cond do
        String.slice(color, 0, 1) == "#" ->
          found =
            Enum.find_value(colors, fn {color_key, color_value} ->
              if to_string(color_value) == color, do: color_key, else: false
            end)

          if found do
            IO.puts("Found color name of #{found}")
            true
          else
            IO.puts("No color names or color codes found with the specified query.\nExiting...")
            false
          end

        true ->
          found =
            Enum.find_value(
              colors,
              fn {color_key, color_value} ->
                if to_string(color_key) == color, do: color_value, else: false
              end
            )

          if found do
            IO.puts("Found color value of #{found}")
            true
          else
            IO.puts("No color names or color codes found with the specified query.\nExiting...")
            false
          end
      end
    end

    # use either one of these
    mainloop.(resolve_color, mainloop)
    # Ass4.part1_mainloop(colors);

    IO.puts("== FINISHED ==\n")
  end

  # alternative way to do part 1 (comprised of the next 2 functions) is below
  # these are basically unused because I managed to do the same with anonymous functions
  # I disliked passing around the colors list (like you see below) all the time so I wanted to get rid of that
  # Now I'm passing around functions, and I guess that at least it is more appropriate for this course titled 'functional programming', if nothing else...
  def part1_mainloop(colors) do
    Ass4.part1_resolve_color(
      colors,
      String.trim_trailing(IO.gets("Give a color or a HTML color value: "), "\n")
    )
  end

  def part1_resolve_color(colors, color) do
    cond do
      String.slice(color, 0, 1) == "#" ->
        found =
          Enum.find_value(colors, fn {color_key, color_value} ->
            if to_string(color_value) == color, do: color_key, else: false
          end)

        if found do
          IO.puts("Found color name of #{found}")
          Ass4.part1_mainloop(colors)
        else
          IO.puts("No colors or color codes found with the specified query.\nExiting...")
        end

      true ->
        found =
          Enum.find_value(
            colors,
            fn {color_key, color_value} ->
              if to_string(color_key) == color, do: color_value, else: false
            end
          )

        if found do
          IO.puts("Found color value of #{found}")
          Ass4.part1_mainloop(colors)
        else
          IO.puts("No colors or color codes found with the specified query.\nExiting...")
        end
    end
  end

  def part2 do
    IO.puts("=== PART 2 ===")

    book_map = %{
      "9780007203543" => "Fellowship of the Ring, J.R.R. Tolkien",
      "9780007203550" => "Two Towers, J.R.R. Tolkien",
      "9780007203567" => "Return of the King, J.R.R. Tolkien",
      "9780136083252" => "Clean Code, Robert C. Martin",
      "9780132542883" => "Clean Coder, The, Robert C. Martin"
    }

    mainloop = fn list_func, search_func, add_func, remove_func, main_func, books ->
      input =
        String.trim_trailing(
          IO.gets("Choose an action from: list, search, add, remove, quit: "),
          "\n"
        )

      case input do
        "list" ->
          list_func.(books)
          main_func.(list_func, search_func, add_func, remove_func, main_func, books)

        "search" ->
          search_result = search_func.(books)
          IO.puts("#{search_result}")
          main_func.(list_func, search_func, add_func, remove_func, main_func, books)

        "add" ->
          book_result = add_func.(books)
          main_func.(list_func, search_func, add_func, remove_func, main_func, book_result)

        "remove" ->
          book_result = remove_func.(books)
          main_func.(list_func, search_func, add_func, remove_func, main_func, book_result)

        "quit" ->
          IO.puts("Byebye!")

        _ ->
          IO.puts("Invalid choice \"#{input}\"")
          main_func.(list_func, search_func, add_func, remove_func, main_func, books)
      end
    end

    list_func = fn books ->
      IO.puts("")
      Enum.each(books, fn {isbn, title} -> IO.puts("ISBN: #{isbn}, title: #{title}") end)
      IO.puts("")
    end

    search_func = fn books ->
      input = String.trim_trailing(IO.gets("Enter ISBN to search for: "), "\n")
      IO.puts("")

      result =
        Enum.find_value(
          books,
          fn {isbn, title} ->
            if isbn == input do
              "Match found! \nISBN: #{isbn}, title: #{title}\n"
            end
          end
        )

      unless result, do: "No matches!\n", else: "#{result}"
    end

    add_func = fn books ->
      isbn = String.trim_trailing(IO.gets("Enter ISBN for new book: "), "\n")
      title = String.trim_trailing(IO.gets("Enter title with author for new book: "), "\n")
      IO.puts("All done!\n")
      Map.put_new(books, isbn, title)
    end

    remove_func = fn books ->
      isbn_to_be_removed =
        String.trim_trailing(IO.gets("Enter ISBN of a book to be removed: "), "\n")

      IO.puts("All done!\n")
      Map.delete(books, isbn_to_be_removed)
    end

    mainloop.(list_func, search_func, add_func, remove_func, mainloop, book_map)

    IO.puts("== FINISHED ==\n")
  end

  def ass4_mainloop do
    part1()
    part2()
  end
end
