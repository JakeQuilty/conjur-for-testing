# Conjur For Testing

## Setup

`./setup.sh`

## Info For Testing

- URL: `https://127.0.0.1:8443`
- Account: `myConjurAccount`
- Cert: `conjur-myConjurAccount.pem`
- Data Key: `data_key`
---
To generate the cert from inside the CLI container, the authn url has to be `https://host.docker.internal:8443`. This is the IP of the machine hosting the container.

All references to the Conjur server from inside the CLI must be `conjur`.

## Default Root Policy

### Location
- Local: `./conf/policy/policy.yml`
- CLI Container: `/policy/policy.yml`

### Users:
- `admin`
   - API Key: admin_data
### Hosts:
- `hosts/test/myApp`
   - API Key: user_data
   - privileges on `test/secret`: read, execute, update
### Secrets:
- `test/secret`

## Conjur CLI

### .conjurrc
- Location: `/root/.conjurrc`
- Contents:
```
---
account: myConjurAccount
plugins: []
appliance_url: conjur
```