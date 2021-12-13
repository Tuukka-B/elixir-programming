# TCP Server & Client (Assignment 9)

## Linux instructions

* open a terminal tab:
```bash
user@localhost:~/M2296/elixir-programming/assignment_9$ iex -S mix
Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Assignment9.start_server

21:08:47.009 [info]  Accepting connections on port 5544
{:ok, #PID<0.201.0>}
iex(2)> 
```

* open another terminal tab: 

```bash
user@localhost:~/M2296/elixir-programming/assignment_9$ iex -S mix
Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Assignment9.ass9_mainloop
Connection established. Type 'quit' to quit. 
Tell me your name.
testihenkilö
testihenkilö has logged in.
testaaja-tauno has logged in.
haloo
testaaja-tauno: haloo haloo!
testaaja-tauno: toimii :)
jes
testaaja-tauno has logged out.
telnet-tyyppi has logged in.
telnet-tyyppi: hoihoi
moromoro
hei hei mitä kuuluu?
telnet-tyyppi: lähdenkin tästä
telnet-tyyppi has logged out.
quit
Terminating connection and exiting...
:terminate
iex(2)> 
```

* open a third tab as well:
```bash
user@localhost:~/M2296/elixir-programming/assignment_9$ iex -S mix
Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Assignment9.ass9_mainloop
Connection established. Type 'quit' to quit. 
Tell me your name.
testaaja-tauno
testaaja-tauno has logged in.
testihenkilö: haloo
haloo haloo!
toimii :)
testihenkilö: jes
quit
Terminating connection and exiting...
:terminate
iex(2)> 
```

* BONUS: use telnet

```bash
user@localhost:~/M2296/elixir-programming/assignment_9$ telnet localhost 5544
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Tell me your name.
telnet-tyyppi
telnet-tyyppi has logged in.
hoihoi
testihenkilö: moromoro
testihenkilö: hei hei mitä kuuluu?
lähdenkin tästä
^]
telnet> q
Connection closed.
user@localhost:~/M2296/elixir-programming/assignment_9$ 

```

* You can find more documentation and examples [here](./lib/assignment9.ex)

* when in doubt, use iex -S mix
