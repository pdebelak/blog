# Blog

A simple multi-user blog with posts, comments, and tags.

## Installation

* Install [elixir](http://elixir-lang.org/install.html), [postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides), and [yarn](https://yarnpkg.com/en/docs/install)
* Install Elixir dependencies with `mix deps.get`
* Install Node.js dependencies with `yarn`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`

## Running locally

* Set cloudinary env variables in CLOUDEX_API_KEY, CLOUDEX_SECRET, and CLOUDEX_CLOUD_NAME
* Start server with `mix phoenix.server`
* visit [`localhost:4000`](localhost:4000) in your browser.

## Creating users

Users are creating via the command line by running `mix add_user username:DESIRED_USERNAME password:DESIRED_PASSWORD`

## Running tests

* `./bin/test` will run both elixir and javascript tests
