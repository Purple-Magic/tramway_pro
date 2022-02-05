class Estimation::Projects::CalcService < ApplicationService
  attr_reader :project

  def initialize(project)
    if project.associated.present?
      @project = project
    else
      raise 'This project should not be calculated. It does not have associated object'
    end
  end

  def call
    send "calc_#{project.associated.class.name.underscore.gsub('/', '_')}"
  end

  private

  def calc_course
    project.tasks.single.map &:destroy

    course = project.associated

    course.videos.each do |video|
      decorated_video = Courses::VideoDecorator.decorate video
      project.tasks.multiple.each do |task|
        project.tasks.create!(
          title: "#{task.title} | #{decorated_video.title.split(' | ').first}",
          hours: task.hours * video.minutes_of(:duration),
          **task.attributes.symbolize_keys.slice(:price, :specialists_count, :description)
        )
      end
    end
  end

  def calc_product
    project.tasks.single.map &:destroy

    product = project.associated
    
    product.tasks.each do |task|
      project.tasks.create!(
        title: task.title,
        hours: task.estimated_minutes.to_f / 60,
        price: project.default_price,
        specialists_count: 1
      )
    end
  end
end
