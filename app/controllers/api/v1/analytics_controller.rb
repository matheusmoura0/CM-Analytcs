module Api
  module V1
    class AnalyticsController < ApplicationController
      skip_before_action :set_current_user, only: [:create, :batch]

      def create
        event_params = extract_event_params
        event = AnalyticsEvent.create!(event_params)

        # Cache article metadata if present
        if event.article_id.present?
          CacheArticleJob.perform_later(event.article_id, event.metadata)
        end

        render json: { status: 'success', event_id: event.id }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def batch
        events = params[:events]
        return render json: { error: 'No events provided' }, status: :bad_request if events.blank?

        created_events = []
        events.each do |event_data|
          begin
            event = AnalyticsEvent.create!(extract_event_params_from_data(event_data))
            created_events << event.id
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Failed to create event: #{e.message}")
          end
        end

        render json: {
          status: 'success',
          created_count: created_events.length,
          event_ids: created_events
        }, status: :created
      end

      private

      def extract_event_params
        base_params = {
          site_id: params[:site_id] || 'correio-da-manha',
          event_type: params[:event],
          url: params[:url],
          referrer: params[:referrer],
          session_id: params[:session_id] || generate_session_id,
          article_id: params[:article_id],
          title: params[:title],
          author: params[:author],
          section: params[:section],
          position: params[:position],
          device_type: params[:device_type],
          browser: params[:browser],
          os: params[:os],
          country: params[:country],
          city: params[:city],
          scroll_depth: params[:scroll_depth],
          time_on_page: params[:time_on_page],
          metadata: params[:metadata] || {}
        }

        # Classify traffic source
        classification = TrafficSourceClassifier.classify(
          params[:referrer],
          request.domain
        )

        base_params.merge(
          traffic_source: classification[:source],
          traffic_medium: classification[:medium]
        )
      end

      def extract_event_params_from_data(event_data)
        permitted = event_data.permit(
          :site_id, :event, :url, :referrer, :session_id, :article_id, :title,
          :author, :section, :position, :device_type, :browser, :os,
          :country, :city, :scroll_depth, :time_on_page,
          metadata: {}
        ).to_h

        # Add default site_id if not present
        permitted[:site_id] ||= 'correio-da-manha'

        # Classify traffic source
        classification = TrafficSourceClassifier.classify(
          event_data[:referrer],
          request.domain
        )

        permitted.merge(
          traffic_source: classification[:source],
          traffic_medium: classification[:medium]
        )
      end

      def generate_session_id
        SecureRandom.uuid
      end
    end
  end
end
