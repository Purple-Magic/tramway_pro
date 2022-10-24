class PurpleMagic::Api::V1::Products::JiraController < PurpleMagic::Api::ApplicationController
  def create
    webhook = WebhookForm.new Webhook.new
    webhook_params = { service: :jira, params: params, headers: request.headers }
    unless webhook.submit webhook_params
      Airbrake.notify StandardError.new('Webhook is not saved'), **webhook_params
    end

    case params[:webhook_event] 
    when 'worklog_created'
      if params[:worklog][:author][:display_name] == 'Павел Калашников'
        jira_issue_id = params[:worklog][:issue_id]
        task = Products::Task.all.select do |t|
          t['data']['jira_issue_id'] == jira_issue_id
        end.first

        unless task.present?
          task = Products::Task.create! data: { jira_issue_id: jira_issue_id }, product_id: 15
        end
        task.time_logs.create! user_id: 43,
          time_spent: params[:worklog][:time_spent],
          comment: params[:worklog][:comment],
          passed_at: params[:worklog][:created_at]
      end
    end
  end
end
