local config = {}
local prefix = os.getenv("PREFIX") or os.getenv("APPDATA")


config.token = hand_onbot
config.data_path = prefix.."/share/cardwallet_tbot"
config.users_db = config.data_path.."/users/"
config.developer = "432699216"

return config
