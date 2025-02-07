class NotifyJobStatusChannel < ApplicationCable::Channel
  def subscribed
    
    stream_from "notify_job_status_channel_reg@gmail.com"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
