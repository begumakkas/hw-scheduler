class TasksController < ApplicationController
  def index
    matching_tasks = Task.all

    @list_of_tasks = matching_tasks.order({ :created_at => :desc })

    render({ :template => "task_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_tasks = Task.where({ :id => the_id })

    @the_task = matching_tasks.at(0)

    render({ :template => "task_templates/show" })
  end

  def create
    the_task = Task.new
    the_task.course_id = params.fetch("query_course_id")
    the_task.exam_flag = params.fetch("query_exam_flag")
    the_task.due_date = params.fetch("query_due_date")
    the_task.optional_flag = params.fetch("query_optional_flag")
    the_task.priority_rank = params.fetch("query_priority_rank")
    the_task.user_id = params.fetch("query_user_id")
    the_task.status = params.fetch("query_status")
    the_task.description = params.fetch("query_description")
    the_task.due_time = params.fetch("query_due_time")
    the_task.weight_perc = params.fetch("query_weight_perc")
    the_task.task_title = params.fetch("query_task_title")

    if the_task.valid?
      the_task.save
      redirect_to("/tasks", { :notice => "Task created successfully." })
    else
      redirect_to("/tasks", { :alert => the_task.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)

    the_task.course_id = params.fetch("query_course_id")
    the_task.exam_flag = params.fetch("query_exam_flag")
    the_task.due_date = params.fetch("query_due_date")
    the_task.optional_flag = params.fetch("query_optional_flag")
    the_task.priority_rank = params.fetch("query_priority_rank")
    the_task.user_id = params.fetch("query_user_id")
    the_task.status = params.fetch("query_status")
    the_task.description = params.fetch("query_description")
    the_task.due_time = params.fetch("query_due_time")
    the_task.weight_perc = params.fetch("query_weight_perc")
    the_task.task_title = params.fetch("query_task_title")

    if the_task.valid?
      the_task.save
      redirect_to("/tasks/#{the_task.id}", { :notice => "Task updated successfully." } )
    else
      redirect_to("/tasks/#{the_task.id}", { :alert => the_task.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)

    the_task.destroy

    redirect_to("/tasks", { :notice => "Task deleted successfully." } )
  end
  

  def mark_complete
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)

    if params.fetch("query_completed", "0") == "1"
      the_task.status = "completed"
    else
      the_task.status = "not_started"
    end

    if the_task.valid?
      the_task.save
      redirect_back(fallback_location: "/")
    else
      redirect_back({ :fallback_location => "/", :alert => the_task.errors.full_messages.to_sentence })
    end
  end

end
