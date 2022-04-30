package = "cardwallet_tbot"
version = "dev-1"
source = {
   url = "git+https://github.com/MrSyabro/cardwallet_tbot.git",
   branch = "devel",
}
description = {
   homepage = "Кошелек для хранения и бвстрого доступа к номерам банковских карт.",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1",
   "telegram-bot-lua"
}
build = {
   type = "builtin",
   install = {
      bin = { cardbot = "src/init.lua" },
      conf = { confi = "config.lua" },
      lua = {
         serialize = "lib/serialize.lua",
         database = "lib/database.lua"
      },
   }
}
