<p align="center">
  <img src="assets/logo.png" width="220" alt="orc worker with a pickaxe">
</p>

# orc-work-notify

A [Claude Code](https://code.claude.com) plugin that plays a sound on three events, so you can go make tea and come back when it's time:

| Event | Hook | Sound file |
|---|---|---|
| You send a prompt | `UserPromptSubmit` | `submit.wav` |
| Claude needs you (a question, a permission prompt, idle waiting) | `PreToolUse` on `AskUserQuestion`, `Notification` | `attention.wav` |
| Claude finished the task | `Stop` | `stop.wav` |

Sounds play in the background, so they never slow Claude down.

## Install

```sh
claude plugin marketplace add vagkaratzas/orc-work-notify
claude plugin install orc-work-notify@orc-work-notify
```

Then restart Claude Code or run `/reload-plugins`.

## Sounds

It ships with three orc clips from John Carroll's free [Orc Voice Pack](https://johncarroll.itch.io/orc-voice-pack) (CC0, public domain):

| Event | File | From the pack |
|---|---|---|
| `submit` | `sounds/submit.wav` | `yes1.wav` |
| `attention` | `sounds/attention.wav` | `yescommand.wav` |
| `stop` | `sounds/stop.wav` | `satisfied1.wav` |

Thanks, John ([@jhncrrll_](https://x.com/jhncrrll_))!

### Bring your own orc

Prefer a different orc? Any orc. *That* orc. Drop your own `.wav` files in, named after the event; the most specific wins:

| Where | Applies to |
|---|---|
| `~/.claude/sounds/{submit,attention,stop}.wav` | every project |
| `<project>/.claude/sounds/{submit,attention,stop}.wav` | that project only |

They live outside the plugin, so updates never overwrite them, and copyrighted clips you own a copy of stay on your machine instead of in this repo. Skip a file to keep the bundled one.

## Mute

Any non-empty `~/.claude/orc-work-notify.muted` silences it:

```sh
echo 1 > ~/.claude/orc-work-notify.muted   # mute
: > ~/.claude/orc-work-notify.muted        # unmute
```

## Players

Tries `afplay` (macOS), `pw-play`, `paplay`, `ffplay`, `aplay`, then `powershell.exe` (Windows, via Git Bash) in that order, falling through when one is missing or fails.

## License

Code: MIT. Bundled sounds: CC0 (see [Sounds](#sounds)).
