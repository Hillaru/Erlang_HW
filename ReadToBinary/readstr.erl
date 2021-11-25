-module(readstr).

-export([fileread/1]).

fileread(Filename) ->
        {Ans,Bin} = file:read_file(Filename),
        if
                Ans == ok -> io:format("~p~n",[erlang:binary_to_list(Bin)]);
                Ans == error -> io:format("Error: ~p~n",[Bin])
        end.



