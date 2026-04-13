# macOS AppleScript Error Codes

## Permission Errors

| Code | Message | Cause | Solution |
|------|---------|-------|----------|
| -1002 | not allowed to send keystrokes | Missing Accessibility permission | System Settings → Privacy → Accessibility → Add osascript/cliclick/node |
| -1719 | not allowed assistive access | Missing Accessibility permission | Same as above |

## AppleScript Errors

| Code | Message | Cause | Solution |
|------|---------|-------|----------|
| -1708 | doesn't understand message | App doesn't support this command | Check app's AppleScript dictionary with `sdef /Applications/App.app` |
| -1728 | can't get property | Property doesn't exist or access denied | App may have limited AppleScript support |
| -10000 | AppleEvent handler failed | Generic failure | Check syntax, app state, or permissions |
| -10006 | can't set property | Property is read-only or syntax issue | Try alternative approach, avoid reserved words |
| -1700 | can't convert to type | Type mismatch | Check data types in script |

## Screenshot Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "could not create image from display" | Missing Screen Recording permission | System Settings → Privacy → Screen Recording → Add node/terminal |

## Common Fixes

### Permission Reset
```bash
# Reset specific permission (use cautiously)
tccutil reset Accessibility
tccutil reset ScreenCapture
```

### Check App AppleScript Support
```bash
# View app's AppleScript dictionary
sdef /Applications/AppName.app
```

### Test Permission
```bash
# Test Accessibility
osascript -e 'tell application "System Events" to key code 0' 2>&1 | grep -q "不允许" && echo "No permission" || echo "Has permission"

# Test Screen Recording
screencapture -x /tmp/test.png && echo "Has permission" || echo "No permission"
rm -f /tmp/test.png
```
