#!/usr/bin/env lua
config = require "config"
local s = require ("serialize")
local fs = require ("lfs")
if not fs.attributes(config.data_path) then
  fs.mkdir(config.data_path)
  fs.mkdir(config.users_db)
end
local users = require ("database").new_db(config.users_db)
print("[MAIN] Connecting...")
local api = require ("telegram-bot-lua.core").configure(config.token)
--local stop = false
function api.on_message(message)
  
end



api.run()