%%%-------------------------------------------------------------------
%%% @author hillaru
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Dec 2021 12:55 PM
%%%-------------------------------------------------------------------
-module(serv).
-author("hillaru").
-export([passive/1]).

fileread(Filename) ->
    {Ans,Bin} = file:read_file(Filename),
    if
        Ans == ok -> erlang:binary_to_list(Bin);
        Ans == error -> error
    end.

cycle(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    {ok, Msg} = gen_tcp:recv(Socket,0),
    io:format("~p~n",[Msg]),

    Path = string:trim(string:nth_lexeme(Msg, 2, " "), both, "/"),
    if  Path == "" -> io:format("~p~n",[Path]),gen_tcp:send(Socket, fileread("MainMenu"));
        Path == "favicon.ico" -> io:format("~p~n",[Path]),ok;
        true -> String = fileread(Path),
            if  String == error -> io:format("~p~n",[Path]),gen_tcp:send(Socket, fileread("MainMenu"));
                true -> io:format("~p~n",[Path]),gen_tcp:send(Socket, fileread(Path))
            end
    end,

    gen_tcp:close(Socket),
    if Path /= "EXIT" ->
    cycle(ListenSocket) end,
    ok.


passive(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}, {reuseaddr, true}]),
    cycle(ListenSocket).