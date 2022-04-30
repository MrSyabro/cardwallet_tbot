local s = require ("serialize")
local fs = require ("lfs")

local M = {}

local function save_data(filepath, data)
  local file = io.open(filepath, "w")
  local data_str = s.ser(data)
  file:write(data_str)
  file:close()
end

local function data_exists(self, data)
  if type(data) == "table" then data = data.id end
  if self.db[data] then return true end
  return false
end

local function load_index(path)
	local out = {}
	for i in fs.dir(path) do
		if i ~= "." and i ~= ".." then
			table.insert(out, i:match("(%d+).lua"))
		end
	end

	return out
end

local function mt_index (db, key)
  if db.db[key] then return db.db[key] end
  local file = io.open(db.config.path..tostring(key)..".lua")
  if not file then return nil end
  local data_str = file:read("a")
  file:close()
  local data = load("return "..data_str, "data_loader", "bt", {})()
  db.db[key] = data
  return data
end

local function mt_newindex (db, key, data)
	save_data(db.config.path..key..".lua", data)
	if not db.db[key] then table.insert(db.index, key) end
  db.db[key] = data
end

local db_metatable = {
  __index = mt_index,
  __newindex = mt_newindex
}

local function search_with_key(self, key, value)
	for _, i in ipairs(self.index) do
		local data = mt_index(self, i)
		if data[key] then
      if type(data[key]) == "string" then
        local t = (data[key]):match(value)
        if t and t ~= "" then
			    return i, data
        end
      elseif data[key] == value then
        return i, data
      end
		end
	end
end

function M.new_db (path)
  local db = {}
  db.config = {}
  db.db = setmetatable({}, {__mode="kv"})
  db.index = load_index(path)
  db.config.path = path
  
  db.search = search_with_key
  db.foreach = function (self) return ipairs(self.index) end

  return setmetatable(db, db_metatable)
end

return M
