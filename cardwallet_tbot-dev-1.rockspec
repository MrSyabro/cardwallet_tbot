package = "cardwallet_tbot"
version = "dev-1"
source = {
   url = "git+https://git@github.com/MrSyabro/cardwallet_tbot.git",
   branch = "devel",
}
description = {
   homepage = "Кошелек для хранения и бвстрого доступа к номерам банковских карт.",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.2",
   "telegram-bot-lua",
   "luafilesystem",
}
build = {
   type = "builtin",
   modules = {},
   install = {
      bin = { cardbot = "src/init.lua" },
      conf = { "config.lua" },
      lua = {
         --config = "config.lua",
         serialize = "lib/serialize.lua",
         database = "lib/database.lua"
      },
   }
}
