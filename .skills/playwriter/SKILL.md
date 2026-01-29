---
name: playwriter
description: Control the user's own Chrome browser via Playwriter extension with Playwright code snippets in a stateful local js sandbox via playwriter cli. Automate web interactions, take screenshots, inspect accessibility trees, debug & profile web applications.
---

# Browser Automation with Playwriter

## Important Rules

1. **Be autonomous** — Complete tasks independently. Only ask user for help when absolutely necessary (e.g., CAPTCHA, 2FA, login credentials).
2. **Create your own pages** — Use `context.newPage()` to create pages you control, don't rely on user having tabs open.
3. **Handle errors gracefully** — If something fails, try alternative approaches before giving up.

## Prerequisites & Setup

Playwriter requires two components:
1. **CLI tool** — `playwriter` command
2. **Chrome extension** — Playwriter extension installed and enabled on the tab to control

### Check environment

```bash
# Check if playwriter is installed
if ! command -v playwriter &> /dev/null; then
  echo "❌ playwriter not installed"
  echo "   Run: npm install -g playwriter@latest"
else
  echo "✅ playwriter installed"
fi
```

### Installation

```bash
# Install CLI globally
npm install -g playwriter@latest

# Or use without installing (always use @latest for first command)
npx playwriter@latest session new
bunx playwriter@latest session new
```

### Chrome Extension Setup

1. Install from Chrome Web Store: search "Playwriter" or visit the extension page
2. **Important:** Click the Playwriter extension icon on any tab you want to control
3. If you get "extension is not connected" or "no browser tabs have Playwriter enabled", the agent should create a new page with `context.newPage()` instead of asking user

### Troubleshooting

| Problem | Solution |
|---------|----------|
| `playwriter: command not found` | Run `npm install -g playwriter@latest` |
| "extension is not connected" | Create page with `context.newPage()` or ask user to click extension icon |
| "no browser tabs have Playwriter enabled" | Create page with `context.newPage()` |
| Connection issues | Run `playwriter session reset <id>` to reset session |
| Code execution timeout | Reset session and retry, or break into smaller steps |

## Quick Start

```bash
# Get a session ID first
playwriter session new
# => 1

# Execute code with your session
playwriter -s 1 -e "state.page = await context.newPage(); await state.page.goto('https://example.com')"
playwriter -s 1 -e "console.log(await accessibilitySnapshot({ page: state.page }))"
playwriter -s 1 -e "await state.page.screenshot({ path: 'shot.png', scale: 'css' })"
```

## Full Documentation

**Run `playwriter skill` to get complete, up-to-date documentation** including:
- Session management
- Context variables (`state`, `page`, `context`)
- Best practices and rules
- Accessibility snapshots and screenshots
- Selector strategies
- Working with pages, navigation, popups, downloads
- Utility functions
- Network interception for API scraping

```bash
playwriter skill
```

## Core Concepts

### Session Management

Each session runs in an **isolated sandbox** with its own `state` object:

```bash
playwriter session new       # Get new session ID
playwriter session list      # List active sessions
playwriter session reset <id> # Reset if connection is stale
```

**Always use `-s <sessionId>`** to persist state across commands.

### Context Variables

- `state` — object persisted between calls within your session
- `page` — default page (if user enabled extension on a tab)
- `context` — browser context, access all pages via `context.pages()`
- `require` — load Node.js modules

### Execute Code

```bash
playwriter -s <sessionId> -e "<code>"
```

Default timeout is 10 seconds. Increase with `--timeout <ms>`.

### Key Rules

1. **Use your own session** — prevents interference from other agents
2. **Store pages in state** — `state.myPage = await context.newPage()`
3. **Never close browser/context** — only close pages you created
4. **Check state after actions** — verify page state after clicking/submitting
5. **Clean up listeners** — `page.removeAllListeners()` at end of tasks

## Common Patterns

### Create your own page (recommended)

```js
state.page = await context.newPage();
await state.page.goto('https://example.com', { waitUntil: 'domcontentloaded' });
await waitForPageLoad({ page: state.page, timeout: 5000 });
```

### Check page state after actions

```js
console.log('url:', page.url()); console.log(await accessibilitySnapshot({ page }).then(x => x.split('\n').slice(0, 30).join('\n')));
```

### Accessibility snapshot with aria-ref

```js
// Get snapshot
console.log(await accessibilitySnapshot({ page }));

// Click using aria-ref (no quotes around ref value)
await page.locator('aria-ref=e13').click();

// Search for specific elements
const snapshot = await accessibilitySnapshot({ page, search: /button|submit/i });
```

### Screenshots

```js
// Always use scale: 'css' for proper sizing
await page.screenshot({ path: 'shot.png', scale: 'css' });

// Visual screenshot with element labels (best for understanding page layout)
await screenshotWithAccessibilityLabels({ page });
```

### Click elements reliably

```js
// Method 1: Using locator with force click
await page.locator('button').first().click({ force: true });

// Method 2: Using page.evaluate for stubborn elements
await page.evaluate(() => {
  document.querySelector('[data-testid="like"]').click();
});

// Method 3: Filter and find specific elements
const tweet = page.locator('article').filter({ hasText: 'target text' }).first();
await tweet.locator('button').click();
```

### Network interception for API scraping

```js
state.responses = [];
page.on('response', async res => { 
  if (res.url().includes('/api/')) { 
    try { state.responses.push({ url: res.url(), body: await res.json() }); } catch {} 
  } 
});
```

## Debugging

```bash
# View relay server logs
playwriter logfile

# Reset stale session
playwriter session reset <id>
```

## Tips for Twitter/X Automation

- Tweet like buttons use `data-testid="like"` when unliked, changes when liked
- Use `page.locator('article[data-testid="tweet"]')` to find tweets
- Check `aria-label` attribute for like status (contains "Liked" if already liked)
- Scroll with `page.mouse.wheel(0, pixels)` to load more content
- Use `getCleanHTML` with search to find specific content quickly
