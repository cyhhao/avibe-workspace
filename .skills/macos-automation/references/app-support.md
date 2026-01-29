# App-Specific AppleScript Support

## Full Support ✅

### Messages (iMessage)
- Send messages ✅
- Read conversations ✅
- Get buddy list ✅

```applescript
tell application "Messages"
    set targetService to 1st account whose service type = iMessage
    set targetBuddy to participant "recipient" of targetService
    send "message" to targetBuddy
end tell
```

### Reminders
- Create reminders ✅
- Set due dates ✅
- Access lists ✅

```applescript
tell application "Reminders"
    tell default list
        make new reminder with properties {name:"Title", due date:(current date) + 1 * days}
    end tell
end tell
```

### Finder
- File operations ✅
- Desktop icon positioning ✅
- Window control ✅

```applescript
tell application "Finder"
    set desktop position of item "filename" of desktop to {100, 100}
end tell
```

### Music (Apple Music)
- Playback control ✅
- Track info ✅
- Playlist access ✅

```applescript
tell application "Music"
    play
    pause
    next track
    previous track
end tell
```

### Safari
- Open URLs ✅
- Get current URL ✅
- Tab control ✅

## Limited Support ⚠️

### WeChat
- Window control ✅
- Get app state ✅
- **Send messages ❌**

```applescript
-- Only basic properties work
tell application "WeChat"
    get frontmost
    get name
    get version
end tell
```

### NeteaseMusic
- Activate app ✅
- Window control ✅
- **No playback API**

Workaround: Use URL schemes + key simulation
```bash
open "orpheus://radio"
osascript -e 'tell application "NeteaseMusic" to activate'
osascript -e 'tell application "System Events" to key code 49'
```

## No AppleScript Support ❌

### Telegram
- No scripting dictionary
- Workaround: Use Telegram Bot API

### WhatsApp
- No scripting dictionary
- Workaround: Use WhatsApp Business API or web automation

### Slack
- No scripting dictionary
- Workaround: Use Slack API

## URL Schemes for Unsupported Apps

| App | Scheme | Example |
|-----|--------|---------|
| WeChat | weixin:// | `open "weixin://"` |
| Telegram | tg:// | `open "tg://resolve?domain=username"` |
| WhatsApp | whatsapp:// | `open "whatsapp://send?phone=NUMBER"` |
| NeteaseMusic | orpheus:// | `open "orpheus://song/123456"` |
| Spotify | spotify:// | `open "spotify:track:TRACKID"` |

## Checking App Support

```bash
# Check if app has AppleScript dictionary
sdef /Applications/AppName.app

# List available commands
osascript -e 'tell application "AppName" to properties'
```
