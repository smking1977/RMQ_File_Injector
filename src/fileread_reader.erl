-module(fileread_reader).

-export([start/0,
	 process/1]).

start() ->
     io:fwrite("Reading Files\n"),
    {ok, Files} = file:list_dir(fileread:get_dir()),
    io:fwrite("Files Count ~w ~n ", [length(Files)]),
    S1 = erlang:system_time(seconds),
    process(Files),
    S2 = erlang:system_time(seconds),  
    io:fwrite("Processing time : ~w seconds ~n ", [(S2 - S1)]),
    io:fwrite("Files  ~w ~n ", [length(Files)]),
    io:fwrite("TPS:  ~w ~n ", [(S2 - S1)/ length(Files)]).

process(Files) ->
 
    {Channel, Connection} = fileread_amqp_client:connect(),
    lists:foreach(fun readData/1, Files),
    fileread_amqp_client:close(Channel, Connection).


readData(Filename) ->
    read_files(Filename, filelib:is_dir(Filename)).

   
read_files (Filename, false) ->
    {ok, _F} =file:read_file(fileread:get_dir() ++ Filename);
   % fileread_amqp_client:send(F);
read_files (_,_) ->
    io:fwrite("Directory  ~n ").

