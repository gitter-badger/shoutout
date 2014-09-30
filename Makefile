PROJECT = shoutout

DEPS = lager cowboy
dep_lager  = git https://github.com/basho/lager.git master
dep_cowboy = git https://github.com/extend/cowboy.git 1.0.0

include erlang.mk

ERLC_OPTS += +'{parse_transform, lager_transform}'
TEST_ERLC_OPTS += +'{parse_transform, lager_transform}'

CT_OPTS += -smp enable \
           -s lager \
           -boot start_sasl \
           -erlargs '-config config/shoutout_test.config'

NODE ?= $(PROJECT)
SHELL_OPTS := -pa ebin \
              -pa deps/*/ebin \
              -smp enable \
              -s lager \
              -boot start_sasl \
              -config config/shoutout.config

console:
	_rel/bin/min console

shell: clean-app app
	if [ -n "$(NODE)" ]; \
	then erl $(SHELL_OPTS) -name $(NODE)@`hostname` -s $(PROJECT); \
	else erl $(SHELL_OPTS) -s $(PROJECT); \
	fi

xref:
	rebar skip_deps=true xref
