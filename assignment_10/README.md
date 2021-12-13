# BooksApi: Phoenix REST API (Assignment 10)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


## Linux install instructions

  * install required packages

```bash
  sudo apt install erlang-dev erlang-parsetools
  sudo apt install postgresql
```

  * edit /etc/postgresql/10/main/pg_hba.conf

```bash
  sudo nano /etc/postgresql/10/main/pg_hba.conf
```
  * -> you have to change the file, instructions: https://stackoverflow.com/questions/35785892/ecto-postgres-install-error-password-authentication-failed#answer-35791275 

## Issues

  * 2 tests fail
    * cause is that the connections loses some attributes ("_format": "json" in this case) in the tests
    * more information: https://stackoverflow.com/questions/47587373/how-can-i-test-a-plug-that-calls-an-action-fallback-controller
    * ...and some more: https://github.com/phoenixframework/phoenix/issues/1879

## Examples

  * start the BooksApi:

```bash
mix phx.server
```
* NOTE: commands here assume you are in the project's root directory

* insert books:

```bash
curl -d @book1.json http://localhost:4000/books -H "Content-Type: application/json"

curl -d @book2.json http://localhost:4000/books -H "Content-Type: application/json"

curl -d @book3.json http://localhost:4000/books -H "Content-Type: application/json"

curl -d @book4.json http://localhost:4000/books -H "Content-Type: application/json"

curl -d @book5.json http://localhost:4000/books -H "Content-Type: application/json"

```

* patch Return of the King by J.R.R. Tolkien (you need the book's id):

```bash
curl -d @book3_patch.json http://localhost:4000/books/<insert-book-id> -H "Content-Type: application/json" -X PATCH

```

* delete Return of the King by J.R.R. Tolkien (you need the book's id):

```bash
curl http://localhost:4000/books/<insert-book-id>  -X DELETE

```


* overwrite Fellowship of The Ring entry by the just deleted Return of the King by J.R.R. Tolkien (you need the book's id (Fellowship of the Ring)):

```bash
curl -d @book3.json http://localhost:4000/books/<insert-book-id> -H "Content-Type: application/json" -X PUT

```
