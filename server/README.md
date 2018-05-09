# allo-workday server

Server for the Allo-Workday application.

## Prerequisites

You will need SQLite and [Leiningen][] 2.0.0 or above installed.

[leiningen]: https://github.com/technomancy/leiningen

For Debian/Ubuntu users:

    $ sudo apt install sqlite3 leiningen

## Setup

You must create a SQLite database:

    $ mkdir db
    $ touch database.db
    $ sqlite3 db/database.db < sql/db.sql

## Running

To start a web server for the application, run:

    lein ring server

## License

MIT
