# frozen_string_literal: true

class WebhookJob < AsyncJob
  def perform(event_type, payload)
    return false if Setting.webhook_url.blank?

    payload[:event] = event_type
    conn = Faraday.new(Setting.webhook_url)
    begin
      conn.post do |req|
        req.headers["Content-Type"] = "application/json"
        req.headers["Event-Host"] = Setting.domain
        req.body = payload.to_json
        req.options.timeout = 5
      end
    rescue => e
      Rails.logger.error("Webhook Error: #{e}")
      return
    end
  end
end
