# MCP on Rails - Deployment Guide

## 🚀 Deploy to Render

### Step 1: Push to GitHub

```bash
cd /home/gagabox5678/mcp-on-rails/myapp
git add .
git commit -m "Add Render deployment config and MCP authentication"
git push origin main
```

### Step 2: Create Render Account

1. Go to [render.com](https://render.com) and sign up
2. Connect your GitHub account

### Step 3: Deploy using Blueprint (Recommended)

1. Click **New** → **Blueprint**
2. Connect your repository
3. Render will auto-detect `render.yaml`
4. Add environment variables:
   - `RAILS_MASTER_KEY`: Copy from `config/master.key`
   - `MCP_API_KEY`: Your secret key (e.g., `mcp-secret-key-12345`)
   - `AZURE_DEVOPS_PAT`: (Optional) Your Azure DevOps token
   - `AZURE_DEVOPS_ORG`: (Optional) e.g., `bananacoding`

### Step 4: Wait for Deployment

Render will:

- Build Docker image
- Create PostgreSQL database
- Run migrations
- Start the app

Your URL will be: `https://mcp-on-rails.onrender.com`

---

## 🔗 Share with Others

### For Others to Connect Claude Desktop:

1. **Install Node.js** (for npx command)

2. **Edit Claude Desktop config:**

   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`

3. **Add this configuration:**

```json
{
  "mcpServers": {
    "mcp-on-rails": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://YOUR-APP-NAME.onrender.com/mcp",
        "--header",
        "Authorization: Bearer YOUR_MCP_API_KEY"
      ]
    }
  }
}
```

4. **Restart Claude Desktop**

5. **Test by asking:** "แสดงรายการ posts ทั้งหมด"

---

## 🔑 Environment Variables Reference

| Variable           | Required | Description                           |
| ------------------ | -------- | ------------------------------------- |
| `RAILS_MASTER_KEY` | ✅       | From `config/master.key`              |
| `MCP_API_KEY`      | ✅       | Your chosen secret (share with users) |
| `DATABASE_URL`     | ✅       | Auto-set by Render PostgreSQL         |
| `AZURE_DEVOPS_PAT` | ❌       | Azure DevOps Personal Access Token    |
| `AZURE_DEVOPS_ORG` | ❌       | Azure DevOps organization name        |

---

## 🧪 Test MCP Authentication

```bash
# Without API key - should return 401
curl https://YOUR-APP.onrender.com/mcp

# With API key - should work
curl -H "Authorization: Bearer YOUR_MCP_API_KEY" https://YOUR-APP.onrender.com/mcp
```

---

## ⚠️ Important Notes

1. **Free tier** sleeps after 15 mins of inactivity (first request may take 30-60 seconds)
2. **Database** is persistent - data survives deploys
3. **Share MCP_API_KEY** only with trusted users
4. **Render URL** may change if you rename the service
