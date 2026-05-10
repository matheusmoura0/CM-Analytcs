class HealthController < ApplicationController
  def index
    render json: {
      status: 'healthy',
      timestamp: Time.current,
      version: '1.0.0',
      database: check_database
    }
  end
  
  private
  
  def check_database
    ActiveRecord::Base.connection.active?
  rescue
    false
  end
end
