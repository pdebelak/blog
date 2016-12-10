# Blog

A simple multi-user blog with posts, comments, and tags.

## Installation

* Install Elixir dependencies with `mix deps.get`
* Install Node.js dependencies with `npm install`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`

## Running locally

* Start server with `mix phoenix.server`
* visit [`localhost:4000`](localhost:4000) in your browser.

## Creating users

Users are creating via the command line by running `mix add_user
username:DESIRED_USERNAME password:DESIRED_PASSWORD`

## Running tests

* `./bin/test` will run both elixir and javascript tests
