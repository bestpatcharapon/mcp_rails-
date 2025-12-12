MCP::EmptyProperty = Class.new

# Require all tools to be able to list dependencies of MCP::Tool
Rails.application.config.to_prepare do
  Dir[Rails.root.join("app/tools/**/*.rb")].each do |file|
    require_dependency file
  end
end

# MCP Authentication Middleware
# Checks for valid API key in Authorization header
class McpAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    
    # Skip auth for non-MCP endpoints
    unless request.path.start_with?("/mcp")
      return @app.call(env)
    end
    
    # Skip auth if no API key is configured (development mode)
    api_key = ENV["MCP_API_KEY"]
    if api_key.blank?
      Rails.logger.warn "MCP_API_KEY not set - allowing unauthenticated access"
      return @app.call(env)
    end
    
    # Check Authorization header
    auth_header = env["HTTP_AUTHORIZATION"]
    
    if auth_header.blank?
      return unauthorized_response("Missing Authorization header")
    end
    
    # Support both "Bearer <token>" and plain "<token>" formats
    token = auth_header.sub(/^Bearer\s+/i, "").strip
    
    if token != api_key
      return unauthorized_response("Invalid API key")
    end
    
    @app.call(env)
  end
  
  private
  
  def unauthorized_response(message)
    [
      401,
      { "Content-Type" => "application/json" },
      [{ error: message, hint: "Set Authorization header with your MCP_API_KEY" }.to_json]
    ]
  end
end

# Insert middleware before MCP routes
Rails.application.config.middleware.insert_before 0, McpAuthMiddleware
