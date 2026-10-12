#!/usr/bin/env bash
# usage: notify.sh {submit|attention|stop}
case "$1" in submit|attention|stop) ;; *) exit 0 ;; esac

# A non-empty mute file silences every sound (written by a mute toggle, or by hand).
[[ -s "$HOME/.claude/orc-work-notify.muted" ]] && exit 0

# Most specific wins: plugin default < ~/.claude/sounds < <project>/.claude/sounds.
F=""
for D in "${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}/sounds" "$HOME/.claude/sounds" "${CLAUDE_PROJECT_DIR:-.}/.claude/sounds"; do
  [[ -f "$D/$1.wav" ]] && F="$D/$1.wav"
done
# No wav anywhere: fall back to the system's own sounds (submit stays silent).
if [[ -z "$F" ]]; then
  case "$1" in
    stop)      for C in /usr/share/sounds/freedesktop/stereo/complete.oga /System/Library/Sounds/Glass.aiff; do [[ -f $C ]] && F=$C && break; done ;;
    attention) for C in /usr/share/sounds/freedesktop/stereo/message.oga /System/Library/Sounds/Ping.aiff; do [[ -f $C ]] && F=$C && break; done ;;
  esac
fi
[[ -n "$F" ]] || exit 0

# Play in the background so the hook never delays Claude (UserPromptSubmit waits
# on it). Try players in order and fall through on failure: `command -v` only
# proves a binary exists, not that it can play (pw-play errors without a PipeWire node).
(
  for P in afplay pw-play paplay ffplay aplay powershell.exe; do
    command -v "$P" >/dev/null || continue
    case "$P" in
      ffplay) "$P" -nodisp -autoexit -loglevel quiet "$F" ;;
      # Windows (Git Bash): SoundPlayer ships with .NET. Path goes in via env so quotes in it can't break the command.
      powershell.exe) command -v cygpath >/dev/null && ORC_WAV="$(cygpath -w "$F")" "$P" -NoProfile -NonInteractive -Command '(New-Object Media.SoundPlayer $env:ORC_WAV).PlaySync()' ;;
      *)      "$P" "$F" ;;
    esac && exit 0
  done
) </dev/null >/dev/null 2>&1 &
exit 0
