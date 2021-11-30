# frozen_string_literal: true

class Courses::Lesson < ApplicationRecord
  belongs_to :topic, class_name: 'Courses::Topic'

  has_many :videos, -> { order(:position) }, class_name: 'Courses::Video'
  has_many :tasks, -> { order(:position) }, class_name: 'Courses::Task'

  ::Course::TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      joins(topic: :course).where 'courses.team' => team
    }
  end

  def progress_status
    done_videos = videos_with(status: :done).count
    done_tasks = tasks_with(status: :uploaded).count
    started_videos = videos_without(status: :ready).count
    started_tasks = tasks_without(status: :written).count

    conditions.each do |condition|
      video_condition = condition[1][:videos].call(videos.active.count, started_videos, done_videos,
        videos_with_comments_any)
      task_condition = condition[1][:tasks].call(tasks.active.count, started_tasks, done_tasks,
        tasks_with_comments_any)
      return condition[0] if video_condition && task_condition
    end
  end

  def conditions
    {
      done: done_conditions,
      in_progress: in_progress_conditions
    }
  end

  def done_conditions
    {
      videos: lambda do |all, started, done, _with_comments_any|
        started.positive? && started == all && all == done
      end,
      tasks: lambda do |_all, _started, _done, _with_comments_any|
        tasks.empty? || tasks.map(&:progress_status).uniq == [:done]
      end
    }
  end

  def in_progress_conditions
    {
      videos: lambda do |all, started, done, with_comments_any|
        (all.positive? && with_comments_any) || started != done
      end,
      tasks: lambda do |all, started, done, with_comments_any|
        tasks.any? ? (all.positive? && with_comments_any) || started != done : true
      end
    }
  end

  def videos_with_comments_any
    videos.active.map { |video| video.comments.active.count }.uniq != [0]
  end

  def tasks_with_comments_any
    tasks.active.map { |task| task.comments.active.count }.uniq != [0]
  end

  def videos_with(status:)
    videos.active.select { |video| video.progress_status == status }
  end

  def tasks_with(status:)
    tasks.active.select { |task| task.progress_status == status }
  end

  def videos_without(status:)
    videos.active.reject { |video| video.progress_status == status }
  end

  def tasks_without(status:)
    tasks.active.reject { |task| task.progress_status == status }
  end
end
