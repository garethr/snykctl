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

At the moment `snykctl` has one subcommand, `api`, which provides very low level access to the API. 

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
$ snykctl api org e1fde430-36f8-43a5-bd6b-7be6ss99b42b membersxx
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

The [Test requirements file](https://snyk.docs.apiary.io/#reference/test/pip/test-requirements.txt-file) API:

```console
$ snykctl api -m post --data fixtures/data.json test pip "?org=e1fde430-36f8-43a5-bd6b-7be6ss99b42"
{
  "ok": false,
  "issues": {
    "vulnerabilities": [
      {
        "id": "SNYK-PYTHON-FLASK-42185",
        "url": "https://snyk.io/vuln/SNYK-PYTHON-FLASK-42185",
        "title": "Improper Input Validation",
        "type": "vuln",
        "description": "## Overview\n[flask](https://pypi.org/project/Flask/) is a lightweight WSGI web application framework.\n\nAffected versions of this package are vulnerable to Improper Input Validation. It did not detect the encoding of incoming JSON data as one of the supported UTF encodings, and allowed arbitrary encodings from the request.\n\n## Remediation\nUpgrade `flask` to version 0.12.3 or higher.\n\n## References\n- [GitHub PR](https://github.com/pallets/flask/pull/2691)\n- [GitHub Release Tag](https://github.com/pallets/flask/releases/tag/0.12.3)\n",
        "from": [
          "flask@0.12"
        ],
        "package": "flask",
        "version": "0.12",
        "severity": "high",
        "exploitMaturity": "no-known-exploit",
        "language": "python",
        "packageManager": "pip",
        "semver": {
          "vulnerable": [
            "[,0.12.3)"
          ]
        },
        "publicationTime": "2018-08-21T14:16:13.738000Z",
        "disclosureTime": "2018-04-10T19:12:29.035000Z",
        "isUpgradable": false,
        "isPatchable": false,
        "isPinnable": true,
        "identifiers": {
          "CVE": [
            "CVE-2018-1000656"
          ],
          "CWE": [
            "CWE-20"
          ]
        },
        "credit": [
          "Unknown"
        ],
        "CVSSv3": "CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H",
        "cvssScore": 7.5,
        "patches": [],
        "upgradePath": []
      },
...
```

All methods of the API should be accessible by passing:

* The HTTP method for the API call with `--method` 
* Any required data, using `--data`. This accepts raw data or a path to a file

If you run into problems then `--debug` provides more details about the requests made that may help identify the issue.
