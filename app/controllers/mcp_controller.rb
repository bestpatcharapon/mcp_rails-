# frozen_string_literal: true

class McpController < ActionController::API
  def handle
    if request.get?
      render json: { status: "online", message: "MCP Server is running" }
    elsif params[:method] == "notifications/initialized"
      head :accepted
    else
      body = request.body.read
      if body.present?
        render(json: mcp_server.handle_json(body))
      else
        render json: { error: "Missing request body" }, status: :bad_request
      end
    end
  end

  private

  def mcp_server
    MCP::Server.new(
      name: "rails_mcp_server",
      version: "1.0.0",
      tools: MCP::Tool.descendants
    )
  end
end
