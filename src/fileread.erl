-module(fileread).
-export([ start/0,
	make/0,
	get_dir/0]).


make() ->
    make:all([load]).

start() ->
    application:ensure_all_started(?MODULE).

get_dir() ->
    "/Users/IW-SteveK/projects/Hermes/2016-08-31/data-trim/ha.inbound.track.event.queue/".
