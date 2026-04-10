# Automation

This repo includes a daily sync pipeline so the `chezmoi` source stays up to date with changes made on the machine.

## Components

| File | Role |
| --- | --- |
| `dot_local/bin/executable_chezmoi-auto-sync` | refreshes source, commits changes, rebases, pushes |
| `dot_config/systemd/user/chezmoi-auto-sync.service` | one-shot user service that runs the sync script |
| `dot_config/systemd/user/chezmoi-auto-sync.timer` | daily timer that triggers the service |

## What The Sync Script Does

The sync job runs this flow:

1. `chezmoi re-add --re-encrypt`
2. detect whether the source repo actually changed
3. `git add -A`
4. create a commit only if needed
5. `git pull --rebase` from the current branch
6. `git push` back to `origin`

This keeps day-to-day config edits flowing back into the repo automatically.

## Schedule

The timer is configured as:

```ini
OnCalendar=daily
Persistent=true
RandomizedDelaySec=30m
```

That means:

- it runs once per day
- missed runs are caught up after login because `Persistent=true`
- the actual start time is jittered to avoid a fixed exact minute every day

## Manual Commands

Run the job immediately:

```bash
systemctl --user start chezmoi-auto-sync.service
```

Check timer status:

```bash
systemctl --user status chezmoi-auto-sync.timer
```

Check service status:

```bash
systemctl --user status chezmoi-auto-sync.service
```

Read logs:

```bash
journalctl --user -u chezmoi-auto-sync.service
```

## Failure Modes

### Git authentication fails

The service exits non-zero and the logs will show the `git push` error.

### Remote changed in a conflicting way

`git pull --rebase` may fail. In that case, resolve the repository state manually in `~/.local/share/chezmoi`, then rerun the service.

### GPG is unavailable

Encrypted files may fail to re-add correctly if the expected key is missing or locked in a way the service cannot use.

### Unwanted files start appearing

Update `.chezmoiignore` and re-run:

```bash
chezmoi re-add --re-encrypt
```

## Why This Exists

The point of the automation is to reduce drift between the live machine and the tracked source repo. When config changes happen naturally over time, the repo should keep up without needing a manual export habit every single day.
