[![](https://api.travis-ci.com/rcedwards/IdiotBoxReprise.svg)](https://travis-ci.com/github/rcedwards/IdiotBoxReprise)
# IdiotBox Reprise

## TVDBKit

Swift API for [The TVDB](thetvdb.com).

### How to Run

#### Add API Key

Create a `secrets.xcconfig` file with a value for your API_KEY. This file is already part of the Xcode project but ignored in git.

The file should be created at `./TVDBKit/TVDBKit/Resources/secrets.xcconfig`

```bash
TVDB_API_KEY = YOUR_API_KEY
```

#### Targets

`TVDBKit` - Library target
`TVDBKitTests` - Unit Tests
