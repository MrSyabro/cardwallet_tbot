local config = {}
local prefix = os.getenv("PREFIX") or os.getenv("APPDATA") or "/usr/local"

config.token = ""
config.data_path = prefix.."/share/cardwallet_tbot"
config.users_db = config.data_path.."/users/"
config.developer = "432699216"

return config
