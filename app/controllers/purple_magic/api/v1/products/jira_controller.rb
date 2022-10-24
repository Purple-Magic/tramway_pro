class PurpleMagic::Api::V1::Products::JiraController < PurpleMagic::Api::ApplicationController
  def create
    jira_issue_id = params[:worklog][:issue_id]
    task = Products::Task.find_by 'data -> jira_issue_id -> ?', jira_issue_id

    unless task.present?
      task = Products::Task.create! data: { jira_issue_id: jira_issue_id }
    end
  end
end
