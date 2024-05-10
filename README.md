# names

A web API to generate random name pairings. Inspired by [Glitch's friendly-words](https://github.com/glitchdotcom/friendly-words).

## Overview

Naming is hard. This API provides a solution for generating random name pairings effortlessly.

## API Endpoints

### GET /

Returns a random pair of words.

**Query Parameters:**

- `separator`: Optional. Specifies the separator type for the words. Possible values: 'hyphen', 'underscore', 'period'.

### GET /words

Returns a random pair of words.

**Query Parameters:**

- `separator`: Optional. Specifies the separator type for the words. Possible values: 'hyphen', 'underscore', 'period'.

### GET /collections

Returns a pair of words synonymous with 'collection'.

**Query Parameters:**

- `separator`: Optional. Specifies the separator type for the words. Possible values: 'hyphen', 'underscore', 'period'.

### GET /teams

Returns a pair of words synonymous with 'team'.

**Query Parameters:**

- `separator`: Optional. Specifies the separator type for the words. Possible values: 'hyphen', 'underscore', 'period'.

## Architecture

Built using in [Deno](https://deno.com) and hosted on [Fly.io](https://fly.io).

## Resources

- [glitchdotcom/friendly-words](https://www.npmjs.com/package/friendly-words)
- [manage dependencies](https://docs.deno.com/runtime/tutorials/manage_dependencies)
- [testing](https://docs.deno.com/runtime/manual/basics/testing/)
- [testing of http requests](https://medium.com/deno-the-complete-reference/unit-testing-of-http-server-in-deno-a03b1c028f92)
- [Deno with Docker](https://github.com/denoland/deno_docker)
