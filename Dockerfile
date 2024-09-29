# rebar3 is needed for esqlite3 
FROM ghcr.io/gleam-lang/gleam:v1.5.1-erlang AS base

COPY . .

FROM base AS build

RUN gleam export erlang-shipment

FROM cgr.dev/chainguard/erlang:latest AS release
WORKDIR /app

COPY --from=build /build/erlang-shipment .

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]