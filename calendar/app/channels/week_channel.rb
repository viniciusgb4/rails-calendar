class WeekChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:week_id]

    stream_from "week_channel_#{params[:week_id]}" if valid_week_id?(params[:week_id])

    Rails.logger.info "Subscribed to week_channel_#{params[:week_id]}"
  end

  def unsubscribed
    Rails.logger.info "Unsubscribed called to WeekChannel:#{params[:week_id]}"
    #stop_all_streams
  end

  private

  def valid_week_id?(week_id)
    return false if week_id.nil?
    week_id.match(/\d{4}-\d{2}-\d{2}/)
  end

end
