class PurpleMagic::Api::V1::Products::JiraController < PurpleMagic::Api::ApplicationController
  def create
    ENV['PROJECT_URL'] = 'purple-magic.com'

    webhook = WebhookForm.new Webhook.new
    unless webhook.submit service: :jira, params: params
      Airbrake.notify StandardError.new('Webhook is not saved'), service: :jira, params: params[:jira]
    end

    case params[:webhook_event] 
    when 'worklog_created'
      if params[:worklog][:author][:display_name] == 'Павел Калашников'
        jira_issue_id = params[:worklog][:issue_id]
        task = Products::Task.all.select do |t|
          t.data&.dig('jira_issue_id') == jira_issue_id
        end.first

        unless task.present?
          task = Products::Task.create! data: { jira_issue_id: jira_issue_id }, product_id: 15
        end
        task.time_logs.create! user_id: 43,
          time_spent: params[:worklog][:time_spent],
          comment: params[:worklog][:comment],
          passed_at: params[:worklog][:created_at],
          data: { jira_worklog_id: params[:worklog][:id] }
      end
    when 'worklog_deleted'
      time_log = TimeLog.all.select do |t|
        t.data&.dig('jira_worklog_id') == params[:worklog][:id]
      end.first
      time_log.destroy if time_log.present?
    when 'worklog_updated'
      time_log = TimeLog.all.select do |t|
        t.data&.dig('jira_worklog_id') == params[:worklog][:id]
      end.first
      if time_log.present?
        t.update!(
          time_spent: params[:worklog][:time_spent],
          comment: params[:worklog][:comment],
          passed_at: params[:worklog][:created_at],
        )
      end
    end
  end
end
