class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    sort_choice = params.fetch("sort", "due_date")
    filter_choice = params.fetch("filter", "all")

    base_upcoming = current_user.tasks.where.not(status: "completed")
    base_completed = current_user.tasks.where(status: "completed")

    if filter_choice == "exams_only"
      base_upcoming = base_upcoming.where(exam_flag: true)
      base_completed = base_completed.where(exam_flag: true)
    elsif filter_choice == "exclude_optional"
      base_upcoming = base_upcoming.where.not(optional_flag: true)
      base_completed = base_completed.where.not(optional_flag: true)
    elsif filter_choice == "exams_only_exclude_optional"
      base_upcoming = base_upcoming.where(exam_flag: true).where.not(optional_flag: true)
      base_completed = base_completed.where(exam_flag: true).where.not(optional_flag: true)
    end

    if sort_choice == "course"
      @upcoming_tasks = base_upcoming.left_joins(:course).order("courses.name ASC, tasks.due_date ASC, tasks.due_time ASC")
      @completed_tasks = base_completed.left_joins(:course).order("courses.name ASC, tasks.due_date ASC, tasks.due_time ASC")
    elsif sort_choice == "priority"
      @upcoming_tasks = base_upcoming.order(:priority_rank, :due_date, :due_time)
      @completed_tasks = base_completed.order(:priority_rank, :due_date, :due_time)
    else
      @upcoming_tasks = base_upcoming.order(:due_date, :due_time)
      @completed_tasks = base_completed.order(:due_date, :due_time)
    end

    @selected_sort = sort_choice
    @selected_filter = filter_choice

    render template: "home_templates/index"
  end
end
