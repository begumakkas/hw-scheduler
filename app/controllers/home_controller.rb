class HomeController < ApplicationController
  def index
    sort_choice = params.fetch("sort", "due_date")

    base_upcoming = Task.where.not(status: "completed")
    base_completed = Task.where(status: "completed")

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

    render({ :template => "home_templates/index" })
  end



end
