# 🤖 How to Connect Claude Desktop to Our Project

This guide explains how team members can connect their **Claude Desktop App** to our **Rails MCP Server**. This allows Claude to access our project data (Azure DevOps, Database, etc.) directly.

## ✅ Prerequisites

1.  **Download Claude Desktop:** [https://claude.ai/download](https://claude.ai/download)
2.  **Get the API Key:** Ask the project admin for the `MCP_API_KEY` (It is set in the Render Dashboard).

---

## 🛠️ Configuration Steps

1.  Open **Claude Desktop App**.
2.  Click on your profile icon (top right) or go to the File menu.
3.  Select **Settings** -> **Developer**.
4.  Click **Edit Config** (This will open a `claude_desktop_config.json` file in your text editor).
5.  **Copy and Paste** the following configuration into that file:

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

6.  ⚠️ **IMPORTANT:** Replace `YOUR_MCP_API_KEY_HERE` with the actual key shared by the admin.
7.  **Save the file** and **Restart Claude Desktop**.

---

## 🚀 How to Use

Once connected, you will see a small **plug icon 🔌** (or tool icon) in Claude's input bar. This means the connection is active.

### Example Prompts to Try:

**For Azure DevOps:**

> "List all projects in Azure DevOps"
> "Show me the tasks assigned to me in the 'Banana Bootcamp' project"
> "Create a new bug report in 'Banana Bootcamp' titled 'Login page is broken'"
> "What is the status of work item #123?"

**For Database/App:**

> "Show me the latest posts from the database"
> "Create a new post with title 'Hello World'"

---

## ❓ Troubleshooting

- **Claude says "I don't have access...":**

  - Check if the **plug icon** is green/active.
  - Ensure you pasted the `MCP_API_KEY` correctly.
  - Try restarting Claude Desktop completely.

- **"Connection Refused" or "Error":**
  - The server on Render might be sleeping (Free Tier). Wait a minute and try again.
