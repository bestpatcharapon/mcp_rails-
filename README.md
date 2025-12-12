# 🤖 MCP on Rails (Azure DevOps Integration)

A powerful **Model Context Protocol (MCP)** server built with **Ruby on Rails**. This application bridges the gap between AI assistants (like **Claude Desktop**) and your existing tools, specifically **Azure DevOps** and a local **PostgreSQL database**.

Current Deployment: `https://mcp-on-rails.onrender.com`

---

## ✨ Features

- **Azure DevOps Integration**:
  - List Projects, Sprints, and Boards.
  - **Manage Work Items**: List, Create, Update, delete, and Comment on tasks/bugs.
  - **Pipelines & Repos**: Trigger builds, list repositories, and view commits.
  - **Test Plans**: View test suites and test cases.
- **Database Access**: direct interaction with the Rails PostgreSQL database (Posts resource).
- **Security**: Secured via `MCP_API_KEY` authentication.
- **Production Ready**: Dockerized and configured for Render.com deployment.

---

## 🚀 How to Use (For Team Members)

To connect your **Claude Desktop** to this server, follow these simple steps:

### 1. Prerequisites

- **Claude Desktop App**: [Download Here](https://claude.ai/download)
- **MCP API Key**: Get the `MCP_API_KEY` from your project admin.

### 2. Configuration

1.  Open **Claude Desktop**.
2.  Go to **Settings** -> **Developer** -> **Edit Config**.
3.  Add the following to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "mcp-on-rails": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://mcp-on-rails.onrender.com/mcp",
        "--header",
        "Authorization: Bearer YOUR_MCP_API_KEY_HERE"
      ]
    }
  }
}
```

> ⚠️ **Replace `YOUR_MCP_API_KEY_HERE` with the actual key!**

### 3. Start Using

Restart Claude. You should see a 🔌 icon. Try asking:

- _"List all projects in Azure DevOps"_
- _"What tasks are in the 'Banana Bootcamp' project?"_
- _"Create a bug titled 'Login failed' in Banana Bootcamp"_

---

## 🛠️ Local Development

### Prerequisites

- Ruby 3.3.3
- PostgreSQL
- Docker (optional)

### Setup

```bash
# Install dependencies
bundle install

# Setup Database
bin/rails db:prepare

# Start Server
bin/rails server
```

### Environment Variables (.env)

```env
MCP_API_KEY=your_secret_key
RAILS_MASTER_KEY=from_config_master_key
AZURE_DEVOPS_ORG=bananacoding
AZURE_DEVOPS_PAT=your_azure_pat_token
```

---

## 🚢 Deployment (Render)

We use [Render Blueprints](https://render.com/docs/blueprint-spec) for deployment.

1.  Push code to GitHub.
2.  Connect repository to Render.
3.  Add Environment Variables in Render Dashboard:
    - `RAILS_MASTER_KEY`
    - `MCP_API_KEY`
    - `AZURE_DEVOPS_ORG`
    - `AZURE_DEVOPS_PAT`
4.  Deploy!

See [DEPLOYMENT.md](DEPLOYMENT.md) for full details.
