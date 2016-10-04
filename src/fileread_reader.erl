-module(fileread_reader).

-export([start/0,
	 process/1]).

start() ->

    fileread_amqp_client:start(sender),
    {ok, Files} = file:list_dir(fileread:get_dir()),
    io:fwrite("Files Count ~w ~n ", [length(Files)]),
    S1 = erlang:system_time(seconds),
    process(Files),
    S2 = erlang:system_time(seconds),  
    io:fwrite("Processing time : ~w seconds ~n ", [(S2 - S1)]),
    io:fwrite("Files  ~w ~n ", [length(Files)]),
    io:fwrite("TPS:  ~w ~n ", [length(Files)/ (S2-S1)]).

process(Files) ->
 
    lists:foreach(fun readData/1, Files).


readData(Filename) ->
    read_files(Filename, filelib:is_dir(Filename)).

   
read_files (Filename, false) ->
    {ok, F} =file:read_file(fileread:get_dir() ++ Filename),
    fileread_amqp_client:send(sender, F);
read_files (_,_) ->
    io:fwrite("Directory  ~n ").

