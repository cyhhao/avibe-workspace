---
name: macos-automation
description: Automate macOS operations including keyboard/mouse simulation, screenshot and OCR, system notifications, iMessage, Reminders, desktop organization, and media control. Use when performing any macOS automation task such as sending keystrokes to applications, capturing and reading screen content, controlling music playback, organizing desktop files and icons, sending iMessages, or creating reminders.
---

# macOS Automation

Automate macOS operations through AppleScript, shell commands, and compiled Swift tools.

## Prerequisites

### Required Permissions

Before automation works, grant these permissions in System Settings → Privacy & Security:

**Accessibility** (for keyboard/mouse simulation):
```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```
Add: `osascript`, `cliclick`, `node`, terminal app

**Screen Recording** (for screenshots):
```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
```
Add: `node`, terminal app

### Required Tools

Install cliclick if not present:
```bash
brew install cliclick
```

## Core Capabilities

### 1. Keyboard Simulation

**Critical**: Use AppleScript `key code`, not cliclick, for app-specific keystrokes.

```applescript
tell application "TargetApp" to activate
delay 0.3
tell application "System Events"
    key code 49  -- space
end tell
```

Common key codes: 49 (space), 36 (return), 53 (escape), 123-126 (arrows)

### 2. System Media Keys

Use the compiled Swift tool for media control:
```bash
~/.skills/macos-automation/scripts/mediakey play   # play/pause
~/.skills/macos-automation/scripts/mediakey next   # next track
~/.skills/macos-automation/scripts/mediakey prev   # previous track
```

### 3. Screenshot and OCR

```bash
# Capture screen
screencapture -x ~/Desktop/screenshot.png

# Capture region (x,y,width,height)
screencapture -x -R 200,200,800,600 ~/Desktop/crop.png

# OCR image to text
~/.skills/macos-automation/scripts/ocr ~/Desktop/screenshot.png
```

### 4. System Notifications

```bash
osascript -e 'display notification "Message" with title "Title" subtitle "Subtitle" sound name "Glass"'
```

Sound options: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink

### 5. iMessage

```applescript
tell application "Messages"
    set targetService to 1st account whose service type = iMessage
    set targetBuddy to participant "email@example.com" of targetService
    send "Message content" to targetBuddy
end tell
```

### 6. Reminders

```applescript
tell application "Reminders"
    set myList to default list
    tell myList
        make new reminder with properties {name:"Title", body:"Notes", due date:(current date) + 1 * days}
    end tell
end tell
```

### 7. Desktop Organization

Arrange icons in grid:
```applescript
tell application "Finder"
    set allItems to every item of desktop
    set idx to 0
    repeat with anItem in allItems
        set c to idx mod 6
        set r to idx div 6
        set desktop position of anItem to {80 + c * 110, 60 + r * 100}
        set idx to idx + 1
    end repeat
end tell
```

Randomize icons:
```applescript
tell application "Finder"
    repeat with anItem in (every item of desktop)
        set desktop position of anItem to {random number from 30 to 1400, random number from 30 to 800}
    end repeat
end tell
```

### 8. Music Control (NeteaseMusic example)

URL Schemes:
- `orpheus://radio` - Personal FM
- `orpheus://song/ID` - Specific song
- `orpheus://playlist/ID` - Playlist

Play music:
```bash
open "orpheus://radio"
sleep 2
osascript -e 'tell application "NeteaseMusic" to activate'
sleep 0.3
osascript -e 'tell application "System Events" to key code 49'
```

## Important Patterns

### Always Activate Before Keystrokes

Wrong (keystroke goes to wrong app):
```applescript
tell application "System Events" to key code 49
```

Correct:
```applescript
tell application "TargetApp" to activate
delay 0.3
tell application "System Events" to key code 49
```

### Shell Special Characters

Escape or quote special characters in filenames:
```bash
echo "test" > ~/Desktop/'file(1).txt'
mv ~/Desktop/file\&name.png ~/Desktop/folder/
```

## Error Reference

| Code | Meaning | Solution |
|------|---------|----------|
| -1002 | Keystroke not allowed | Add Accessibility permission |
| -1708 | Command not understood | App doesn't support this AppleScript |
| -1728 | Can't get property | App lacks full AppleScript support |

## Scripts Reference

Pre-compiled tools in `scripts/`:
- `mediakey` - System media key control
- `ocr` - Vision framework OCR

See [references/error-codes.md](references/error-codes.md) for complete error reference.
See [references/app-support.md](references/app-support.md) for app-specific AppleScript support details.
