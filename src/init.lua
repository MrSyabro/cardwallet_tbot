#!/usr/bin/env lua
local s = require ("serialize")
local fs = require ("lfs")
local usage_msg = "Usage "..arg[0].." -c config_file"
assert(arg[1] == "-c", usage_msg)
local config = dofile(assert(arg[2], usage_msg))
if not fs.attributes(config.data_path) then
  fs.mkdir(config.data_path)
  fs.mkdir(config.users_db)
end
os.execute("mkdir -p "..config.users_db)
local users = require ("database").new_db(config.users_db)
print("[MAIN] Connecting...")
local api = require ("telegram-bot-lua.core").configure(config.token)
--local stop = false
function api.on_message(message)
  local user = users[message.from.id]
  if not user then
    user = message.from
    user.cards = {}
    users[message.from.id] = user
  end
  
  if message.text then
    if message.text:match("/add") then
      local data, name = message.text:match("/add%s*(%g+)%s*(%w+)")
      if not data
      or not name
      or #data > 280
      or #name > 32
      then
        api.send_message(message.chat.id,
          "Мне не нравятся такие запросы -.-")
        return
      end
      
      if #user.cards >= 50 then
        api.send_message(message.chat.id,
          "А не слишком ли много ты хочешь?")
      end
      
      user.cards[name] = data
      users[user.id] = user
      api.send_message(message.chat.id,
        "Окей. Я сохранил твою белеберду `"..data..
        "`. Можешь отправить ее в любом чате.", "Markdown")
    elseif message.text:match("/get") then
      local name = message.text:match("/get%s*(%w+)")
      local cardnumber = user.cards[name]
      if cardnumber then
        api.send_message(message.chat.id,
          "Получай свою белеберду: `"..cardnumber.."`", "Markdown")
      else
        api.send_message(message.chat.id,
          "Нет такой буквы в алфавите.")
      end
    elseif message.text:match("/del") then
      local name = message.text:match("/del%s*(%w+)")
      local cardnumber = user.cards[name]
      if cardnumber then
        user.cards[name] = nil
        users[user.id] = user
        api.send_message(message.chat.id,
          "Снизвел до атомов")
      else
        api.send_message(message.chat.id,
          "Нет такой буквы в алфавите.")
      end
    elseif message.text:match("/list") then
      local out = {"Тебе лень запомнить "..#user.cards.." записей. Вспоминай:", n=1}
      for name, card in pairs (user.cards) do
        table.insert(out, ("*%s:* ```%s```"):format(name,card))
      end
      api.send_message(message.chat.id,
        table.concat(out, "\n"), "Markdown")
    elseif message.text:match("/help") then
      api.send_message(message.chat.id,
        [[Я могу сохранить строку до 280 символов и предлогать тебе их в чатах.
`/add <data> <name>` - запомнить текст по имени
`/get <name>` - получить текст по имени
`/del <name>` - удалить текст по имени
/list - вывести список текстов с именами
Имена могут содержать только латынские буквы и цифры. Текст может содерать латынские буквы, символы и цифры.]], "Markdown")
    elseif message.text:match("/start") then
      api.send_message(message.chat.id,
        [[Привет. Я бот помощник. Умею хранить любой текст до 280 символов и помогать тебе отправить их в нужный момент.
Напиши `/add <data> <name>` (name только латынские символы) что бы добавить первый текст.
Нажми /help что бы узнать остальные команды.]], "Markdown")
    end
  end
end

function api.on_inline_query(inline_query)
  local user = users[inline_query.from.id]
  if user then
  local id = 1
  local queryes = {}
    for key, cardnumber in pairs(user.cards) do
      if inline_query.query == "" 
      or key:match(inline_query.query)
      then
        table.insert(queryes, api.inline_result()
          :type('article')
          :id(id)
          :title(key)
          :input_message_content(
              api.input_text_message_content(
                cardnumber)
          )
        )
        id = id + 1
      end
    end
    api.answer_inline_query(inline_query.id, queryes, 0, true)
  else
    api.answer_inline_query(
        inline_query.id,
        {}, 0, true, nil, "Start", "test"
    )
  end
end

api.run()