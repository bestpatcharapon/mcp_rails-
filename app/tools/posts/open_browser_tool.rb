module Posts
  class OpenBrowserTool < MCP::Tool
    tool_name "posts-open-browser"
    description "Open the Posts page in the web browser. This will launch the browser and navigate to the posts page at localhost:3001/posts"

    input_schema(
      properties: {},
      required: []
    )

    def self.call(server_context:)
      # Try to open browser based on OS
      url = "http://localhost:3001/posts"
      
      # Try different commands for different OS
      commands = [
        "xdg-open '#{url}'",      # Linux
        "open '#{url}'",           # macOS
        "start '#{url}'"           # Windows
      ]
      
      success = false
      commands.each do |cmd|
        result = system(cmd)
        if result
          success = true
          break
        end
      end

      if success
        MCP::Tool::Response.new([{ 
          type: "text", 
          text: "✅ เปิดหน้า Posts ในเบราว์เซอร์แล้ว!\n\n🔗 URL: #{url}\n\nหน้าเว็บควรจะเปิดขึ้นมาในเบราว์เซอร์ของคุณแล้ว" 
        }])
      else
        MCP::Tool::Response.new([{ 
          type: "text", 
          text: "⚠️ ไม่สามารถเปิดเบราว์เซอร์อัตโนมัติได้\n\n🔗 กรุณาเปิด URL นี้ด้วยตนเอง: #{url}" 
        }])
      end
    rescue StandardError => e
      MCP::Tool::Response.new([{ type: "text", text: "❌ เกิดข้อผิดพลาด: #{e.message}" }])
    end
  end
end
