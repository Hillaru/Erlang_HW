-module(inf).
-export([collect/0]).

collect() ->
	Email = io:fread("what is your email? ", "~ts"),
	Name = io:fread("what is your name? ", "~ts"),
	io:format("User email: ~p | User Name: ~p~n", [Email, Name]).
