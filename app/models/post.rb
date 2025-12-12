class Post < ApplicationRecord
  def to_mcp_response
    <<~MARKDOWN
      ---
      ## 📝 #{title}
      
      **👤 Author:** #{author}
      
      **📅 Created:** #{created_at.strftime("%d %B %Y, %H:%M")}
      
      **📄 Content:**
      > #{content}
      
    MARKDOWN
  end
end
