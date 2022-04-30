local config = {}
local prefix = os.getenv("PREFIX")

config.token = hand_onbot
config.users_db = prefix.."/share/cardbot/users/"
config.developer = "432699216"

return config
