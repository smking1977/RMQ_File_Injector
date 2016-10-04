PROJECT = fileread
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.0.1
DEPS = cowboy gproc  jsx amqp_client 


dep_amqp_client = git://github.com/jbrisbin/amqp_client.git master


SHELL_OPTS =  +P 5000000  +K true  -pa ebin -pa deps/*/ebin -boot start_sasl  -config dev.config  -s rb  -s fileread -sname fileread


include erlang.mk
