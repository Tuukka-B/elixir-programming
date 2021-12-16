# Elixir Programming: A repository for JAMK's course Functional Programming


## Prerequirements

* Have elixir installed (https://joyofelixir.com/a-setup-and-install)

* Are willing to try out things (like playing blackjack and such)

* Read the instructions to get your desired assignment up and running (instructions available in README files)

## Linux instructions

* You will find assignments from 1 to 7 in folder [assignments_1-7](./assignments_1-7/). They are available in a single project
	* -> Run iex -S mix and then on the interpreter execute Ass(x).ass(x)_mainloop
<br>

* Assignment 8 is available in folder [assignments_8](./assignment_8/)

* Assignment 9 is available in folder [assignments_9](./assignment_9/)

* Assignment 10 is available in folder [assignments_10](./assignment_10/)


## Highlights

### TCP Server & Client
* [Assignment 9](./assignment_9/)
* Very comprehensive solution
	* Supports named clients
	* TELNET support
	* Supports multiple clients at once (Group chat)

### Blackjack
* [Assignment 7](./assignments_1-7/lib/ass7)
	* README [HERE](./assignments_1-7/)
* Basic Blackjack game
	* single player
	* no stakes / betting
	* otherwise follows all the blackjack rules
	* pretty-printed cards (for example 11 = "jack")
	
### Periodical Timer
* [Assignment 8](./assignment_8/)
* A timer to repeat user-specified function at any interval
* Features
	* list timers
	* modify repeat time
	* named timers & cancel timer by name
	* cancel-on-repeat: you can specify a return value to automatically cancel timer
		* for example 
		* you want to execute IO.puts "Hello"
		* IO.puts always returns :ok normally
		* if you specify :ok as cancel-on-return the repetition will terminate automatically upon first execution of timer

### REST Controller
* [Assignment 10](./assignment_10/)
* BooksAPI based on [this tutorial](https://www.dairon.org/2020/07/06/simple-rest-api-with-elixir-phoenix.html)
* Features:
	* create book
	* modify book
	* delete book
	* get all books
	* get single book
* JSON files + curl commands for testing stuff is included in the project
