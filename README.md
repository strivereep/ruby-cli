# Client Tool

A simple Ruby CLI utility to search clients and detect email duplicates in a JSON dataset.

## Setup

- Ruby 3.0+
- bundle install (for running specs)

## Usage

- Make bin/cli executable: chmod +x bin/cli
- For search command: bin/cli search --file=data/client.json --value="John"
- For duplicates command: bin/cli duplicates --file=data/client.json
- For help: bin/cli --help

## Assumptions and Decisions made

- For duplicates, emails are compared case-sensitively i.e. john.doe and John.Doe are different
- For search, partial match means substring match to the string and search value are compared case-insensitively i.e. john and John are treated same

## Known limitations

- Only JSON file is considered to be valid file and only supports local files, no url support.
- Simple substring match, if typo result may be different.
- For large json files, it may consume significant memory and slow down the response.
