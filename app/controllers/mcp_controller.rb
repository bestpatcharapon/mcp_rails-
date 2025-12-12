require 'concurrent'

class McpController < ActionController::API
  include ActionController::Live

  # Global thread-safe storage for active client sessions
  # Map session_id => Queue
  @@sessions = Concurrent::Map.new

  def handle
    if request.get?
      sse_connection
    else
      handle_message
    end
  end

  private

  def sse_connection
    response.headers["Content-Type"] = "text/event-stream"
    response.headers["Cache-Control"] = "no-cache"
    response.headers["Last-Modified"] = Time.now.httpdate
    response.headers["X-Accel-Buffering"] = "no"

    session_id = SecureRandom.uuid
    queue = Queue.new
    @@sessions[session_id] = queue

    # Send the 'endpoint' event telling the client where to POST messages
    # In production, this should be the full URL
    post_endpoint = "#{request.base_url}/mcp?sessionId=#{session_id}"
    response.stream.write "event: endpoint\ndata: #{post_endpoint}\n\n"

    begin
      loop do
        if queue.empty?
          response.stream.write ":keepalive\n\n"
          sleep 5
        else
          while !queue.empty?
            msg = queue.pop(true) rescue nil
            if msg
              response.stream.write "event: message\ndata: #{msg}\n\n"
            end
          end
        end
      end
    rescue IOError, ActionController::Live::ClientDisconnected
      # Client disconnected
    ensure
      @@sessions.delete(session_id)
      response.stream.close
    end
  end

  def handle_message
    session_id = params[:sessionId]
    
    if session_id.blank? || !@@sessions.key?(session_id)
      response_data = mcp_server.handle_json(request.body.read)
      render json: response_data
      return
    end

    request_body = request.body.read
    return head :bad_request if request_body.blank?

    result = mcp_server.handle_json(request_body)
    json_result = result.is_a?(String) ? result : result.to_json
    @@sessions[session_id].push(json_result)
    head :accepted
  end

  def mcp_server
    MCP::Server.new(
      name: "rails_mcp_server",
      version: "1.0.0",
      tools: MCP::Tool.descendants
    )
  end
end
