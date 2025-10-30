[![Run specs for the Ruby CLI](https://github.com/strivereep/ruby-cli/actions/workflows/test.yml/badge.svg)](https://github.com/strivereep/ruby-cli/actions/workflows/test.yml)

# Client Tool

A simple Ruby CLI utility to search clients and detect email duplicates in a JSON dataset.

## Setup

### Prerequisites

- Ruby 3.0+

## Usage Instructions

- Clone or download the repo.
- Make bin/cli executable: chmod +x bin/cli
- For search command: bin/cli search --file=data/client.json --value="John"
- For duplicates command: bin/cli duplicates --file=data/client.json
- For help: bin/cli --help

## Running Specs

- bundle install
- bundle exec rspec

## Assumptions and Decisions made

- For duplicates, emails are compared case-sensitively i.e. john.doe and John.Doe are different
- For search, partial match means substring match to the string and search value are compared case-insensitively i.e. john and John are treated same

## Known limitations

- Only JSON file is considered to be valid file and only supports local files, no url support.
- Simple substring match, if typo result may be different.
- For large json files, it may consume significant memory.
- No multi search field support i.e. --key="full_name AND email"
- Only shows the output in the terminal.

## Future Improvements

- Support multi format files: CSV, JSON, YAML.
- Support URL.
- Fuzzy search for better results. For e.g. Jon and John would be treated as one as per Levenshtein distance <= 2. (Trade offs: Complex and slower in performance)
- Support multi field search and duplicate detection.
- Stream parse large JSON files instead of loading the file to the memory (Use Oj gem).
- Support --output flag to save results to CSV/JSON. For e.g. --output=results.json
