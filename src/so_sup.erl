
-module(so_sup).

-behaviour(supervisor).

%% API
-export(
  [ start_link/0
  ]).

%% Supervisor callbacks
-export([init/1]).

-type startlink_err() :: {already_started, pid()} | {shutdown, term()} | term().
-type startlink_ret() :: {ok, pid()} | ignore | {error, startlink_err()}.

%% API functions

-spec start_link() -> startlink_ret().
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% Supervisor callbacks

-spec init(list()) -> {ok,{{term(),term(),term()},[term()]}} | ignore.
init([]) ->
  { ok
  , { { one_for_one % restart strategy
      , 5           % max restart
      , 10          % max time
      }
    , [
      ]}}.
