# Snykctl

A command line tool for interacting with the [Snyk API](https://snyk.docs.apiary.io/).

## Installation

Precompiled executables are available Linux and macOS environments. These are available from [Releases](https://github.com/garethr/snykctl/releases). You can grab those quickly with `wget` like so for Linux:

```console
wget -o snykctl https://github.com/garethr/snykctl/releases/download/v0.1.0/snykctl_v0.1.0_linux-amd64
chmod +x snykctl
```

And for macOS:

```console
wget -o snykctl https://github.com/garethr/snykctl/releases/download/v0.1.0/snykctl_v0.1.0_darwin-amd64
chmod +x snykctl
```

## Usage

Using the API requires a valid API token to be set in the `SNYK_TOKEN` environment variable. The Snyk API is
enabled for all Snyk customers.

```console
$ snykctl
snykctl - Command line tool for interacting with the Snyk API

Usage:
  snykctl [command] [arguments]

Commands:
  api [path ...]  Make Snyk API requests and print raw responses
  help [command]  Help about any command.

Flags:
  -h, --help  Help for this command.
```

At the moment `snykctl` has one subcommand, `api`, which provides very low level GET access to the API. 

[List organizations](https://snyk.docs.apiary.io/#reference/organizations/the-snyk-organization-for-a-request/list-all-the-organizations-a-user-belongs-to) API:

```console
$ snykctl api orgs | jq
{
  "orgs": [
    {
      "name": "some-org",
      "id": "e1fde430-36f8-43a5-bd6b-7be6ss99b42b8",
      "slug": "some-org",
      "url": "https://app.snyk.io/org/some-org",
      "group": null
    },
  ]
}
```

The [List members](https://snyk.docs.apiary.io/#reference/organizations/members-in-organization/list-members) API:

```console
$ snykctl api org e1fde430-36f8-43a5-bd6b-7be6ss99b42b members
[
  {
    "id": "e5e77afc-4ffb-4adc-a450-efd634sds0a3",
    "username": "someone",
    "name": "Some One",
    "email": "someone@example.com",
    "role": "admin"
  }
]
```

Arguments to `api` are converted into paths and requests made to the API.
