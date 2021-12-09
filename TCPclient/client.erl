%%%-------------------------------------------------------------------
%%% @author hillaru
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Dec 2021 12:55 PM
%%%-------------------------------------------------------------------
-module(client).
-author("hillaru").
-export([passive/1]).

cycle(ListenSocket) ->
    {Code, Message} = io:fread("Your message>","~ts"),
    if Code == error -> error_wrong_input;
        Message == ["/Exit"] -> ok;
        true ->
            {ok, Socket} = gen_tcp:accept(ListenSocket),
            {ok, Msg} = gen_tcp:recv(Socket,0),
            io:format("~p~n",[Msg]),
            gen_tcp:send(Socket, Message),
            gen_tcp:close(Socket),
            cycle(ListenSocket)
    end.

passive(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}, {reuseaddr, true}]),
    cycle(ListenSocket).

