FROM mrsyabro/tgbotlua:latest

COPY . .

RUN luarocks make cardwallet_tbot-dev-1.rockspec

CMD ["cardbot", "-c", "/run/secrets/cardbot"]