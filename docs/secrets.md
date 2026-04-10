# Secrets and Encryption

This repo stores secret-bearing files as encrypted `chezmoi` entries instead of plain text.

## Encryption Model

- `chezmoi` source state contains encrypted files
- GPG is used as the encryption backend
- the repo includes `.chezmoi.toml.tmpl` so the GPG recipient setting can be recreated on init
- the actual private key is not stored in the repo

## Encrypted Files

At the time of writing, encrypted entries include files such as:

| File | Why it is encrypted |
| --- | --- |
| `dot_config/gh/encrypted_private_hosts.yml.asc` | GitHub auth host data |
| `dot_config/opencode/encrypted_private_opencode.json.asc` | API keys and provider config |
| `dot_config/DankMaterialShell/encrypted_plugin_settings.json.asc` | plugin tokens and API secrets |
| `dot_config/obs-studio/basic/profiles/Untitled/encrypted_service.json.asc` | stream/service secret data |
| `dot_config/obs-studio/basic/scenes/encrypted_Untitled.json.asc` | secret-bearing scene token data |

## GPG Recipient

The current recipient configured by `.chezmoi.toml.tmpl` is:

```text
47114BE511A35CBB42FB4EEC5F03C0AFD3D85FE0
```

This means any machine that needs to decrypt these files must have the matching private key imported.

## Exported Backup Material

The local backup directory contains:

- `~/Documents/chezmoi-gpg-backup/chezmoi-gpg-public.asc`
- `~/Documents/chezmoi-gpg-backup/chezmoi-gpg-secret.asc`
- `~/Documents/chezmoi-gpg-backup/chezmoi-gpg-revocation.rev`

## Import On Another Machine

```bash
gpg --import ~/Documents/chezmoi-gpg-backup/chezmoi-gpg-public.asc
gpg --import ~/Documents/chezmoi-gpg-backup/chezmoi-gpg-secret.asc
```

Then verify `chezmoi` can read encrypted state:

```bash
chezmoi status
```

## Revocation Certificate

The revocation file exists in case the private key is compromised.

Treat it as important recovery material, but do not use it unless you actually intend to revoke the key.

## Security Guidance

- never commit exported secret keys into any repo
- keep a second offline backup of the secret key if possible
- keep the revocation certificate separate from the normal working copy
- rotate credentials stored in encrypted app config if the private key is ever exposed

## Practical Note

This repo chooses encrypted files over environment-variable templating for mixed config files because many of the secret-bearing files are mostly normal configuration with a few sensitive fields inside. Encrypting the full file keeps the app-facing format intact and avoids template sprawl.
