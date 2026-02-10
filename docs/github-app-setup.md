# GitHub App Setup for Local Development

The app works without a GitHub App for basic development — the homepage, API, and database all function using seed data. You only need this setup to test **webhook integration** (receiving events when issues are labeled, PRs are opened, etc.).

## 1. Create a GitHub App

Go to [github.com/settings/apps/new](https://github.com/settings/apps/new) and fill in:

| Field | Value |
|-------|-------|
| **GitHub App name** | `llm-welcome-dev-<your-name>` (must be globally unique) |
| **Homepage URL** | `http://localhost:4000` |
| **Webhook URL** | Your tunnel URL (see step 2 below) + `/webhooks/github` |
| **Webhook secret** | Generate one: `openssl rand -hex 20` |

### Permissions

Under **Repository permissions:**

| Permission | Access |
|------------|--------|
| Metadata | Read-only |
| Issues | Read-only |
| Pull requests | Read-only |

### Events

Subscribe to these events:

- **Installation** and **Installation repositories**
- **Issues**
- **Pull request**

Click **Create GitHub App**.

## 2. Expose your local server

GitHub needs to reach your local machine to deliver webhooks. You need a tunnel.

**Option A: Tailscale Funnel** (if you use Tailscale)
```bash
tailscale funnel 4000
```

**Option B: ngrok**
```bash
ngrok http 4000
```

**Option C: Cloudflare Tunnel**
```bash
cloudflared tunnel --url http://localhost:4000
```

Copy the public HTTPS URL and paste it as your GitHub App's Webhook URL, appending `/webhooks/github`:
```
https://your-tunnel-url.example.com/webhooks/github
```

## 3. Download the private key

After creating the app:

1. Go to your app's settings page on GitHub
2. Scroll to **Private keys** and click **Generate a private key**
3. A `.pem` file will download — save it somewhere safe (e.g. `~/.ssh/llm-welcome-dev.pem`)
4. Note your **App ID** (shown at the top of the app settings page)

## 4. Configure environment variables

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env`:

```bash
GITHUB_APP_ID=123456
GITHUB_WEBHOOK_SECRET=your-webhook-secret-from-step-1
GITHUB_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----
paste-your-full-pem-contents-here
-----END RSA PRIVATE KEY-----"
```

### Loading the env vars

**Docker path** — automatically loaded:
```bash
make dev          # .env is picked up by docker-compose
make dev.server
```

**Local Elixir path** — export before starting the server:
```bash
source .env
make server
```

Or use [direnv](https://direnv.net/) for automatic loading — create an `.envrc`:
```bash
dotenv
```

## 5. Install the app on a test repo

1. Go to your GitHub App's public page: `https://github.com/apps/llm-welcome-dev-<your-name>`
2. Click **Install** and select a test repository
3. Create an issue and add the `llm-welcome` label
4. Check your server logs — you should see webhook events arrive

## Webhook events handled

| Event | Actions | What happens |
|-------|---------|--------------|
| `installation` | created, deleted | Tracks/removes the GitHub App installation |
| `installation_repositories` | added, removed | Syncs repository list |
| `issues` | labeled, unlabeled, closed, deleted | Tracks issues with the `llm-welcome` label |
| `pull_request` | opened, reopened, closed | Links PRs to issues, records contributions |
