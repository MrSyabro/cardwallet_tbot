FROM imolein/luarocks:5.4

COPY . .

RUN luarocks install luafilesystem
RUN luarocks install telegram-bot-lua
RUN luarocks make cardwallet_tbot-dev-1.rockspec

CMD ["cardbot", "-c", "/run/secrets/cardbot"]