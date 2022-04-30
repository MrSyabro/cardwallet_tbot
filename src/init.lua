#!/usr/bin/env lua
config = require "config"
local s = require ("serialize")
local users = require ("database").new_db(config.users_db)
print("[MAIN] Connecting...")
local api = require ("telegram-bot-lua.core").configure(config.token)handlers = require ("handlers")
local stop = false

function api.on_message(message)
  
end



api.run()