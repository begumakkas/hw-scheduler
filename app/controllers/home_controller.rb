class HomeController < ApplicationController
  def index
    @upcoming_tasks = Task.where.not(status: "completed").order(:due_date, :due_time)
    @completed_tasks = Task.where(status: "completed").order(:due_date, :due_time)

    render({ :template => "home_templates/index" })
  end



end
