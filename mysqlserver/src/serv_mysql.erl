-module(serv_mysql).
-author("hillaru").
-export([passive/0, thread_send/1]).

split_string(String) ->
    [_, Action, Id | _] = string:lexemes(binary_to_list(String), "/ " ++ [[$\r,$\n]]).

fileread(Filename) ->
    {Ans,Bin} = file:read_file(Filename),
    if
        Ans == ok -> erlang:binary_to_list(Bin);
        Ans == error -> error
    end.

output(Data) ->
    write_data(Data, []).

write_data([], Acc) -> ["<tr>", "<td>", "<h4>", "Id", "</h4>", "</td>", "<td>", "<h4>", "Fname", "</h4>", "</td>", "<td>", "<h4>", "Lname", "</h4>" "</td>", "<td>", "<h4>", "Patronymic", "</h4>", "</td>", "<td>", "<h4>", "Passport", "</h4>", "</td>", "<td>", "<h4>", "Phone", "</h4>", "</td>", "</tr>"] ++ lists:reverse(Acc);
write_data([[Id, FName, LName, Patr, Pass, Phone] | TailData], Acc) ->
    write_data(TailData, ["</tr>", "</td>", Phone, "<td>", "</td>", Pass, "<td>", "</td>", Patr, "<td>", "</td>", LName, "<td>", "</td>", FName, "<td>", "</td>", Id, "<td>", "<tr>" | Acc]).


generate_html("favicon.ico", _) ->
    ok;
generate_html("getallstaff", _) ->
    {ok, _, List} = mysql:query(db, <<"SELECT * FROM staff">>),
    "<h1>All Staff data</h1><br>" ++ "<table>" ++ output(List) ++ "</table>";
generate_html("getstaff", Id) ->
    {ok, _, [List]} = mysql:query(db, <<"SELECT * FROM staff WHERE Staff_id = ?">>, [Id]),
    "<h1>Staff data</h1><br>" ++ "<table>" ++ output([List]) ++ "</table>";
generate_html(_, _) ->
    error.

thread_send(Socket) ->
    {ok, Msg} = gen_tcp:recv(Socket,0),
    io:format("~p~n",[Msg]),
    [_, Action, Id | _] = split_string(Msg),
    io:format("Action = ~p~n",[Action]),
    io:format("Id = ~p~n",[Id]),

    Html = generate_html(Action, Id),
    if (Html == error) ->
        Response = fileread("resources/MainMenu.html");
        true -> Response = "HTTP/1.1 200 OK\nContent-Type: text/html; charset=utf-8\n\n\n<html>\n<body\n<p>" ++ Html
    end,
    gen_tcp:send(Socket, Response),
    gen_tcp:close(Socket).

cycle(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(serv_mysql, thread_send, [Socket]),
    cycle(ListenSocket).

passive() ->
    Port = 1480,
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}, {reuseaddr, true}]),
    {ok, Pid} = mysql:start_link([{host, "localhost"}, {user, "hillaru"}, {database, "test_db"}]),
    erlang:register(db, Pid),
    cycle(ListenSocket).
