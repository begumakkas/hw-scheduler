class CoursesController < ApplicationController
  before_action :authenticate_user!

  def index
    matching_courses = current_user.courses
    @list_of_courses = matching_courses.order({ :created_at => :desc })
    # @the_course = current_user.courses.where(id: params.fetch("path_id")).first

    today = Date.today

    @current_courses = current_user.courses.where.not(start_date: nil, end_date: nil)
                                 .where("start_date <= ? AND end_date >= ?", today, today)
                                 .order(:end_date, :name)

    @past_courses = current_user.courses.where.not(end_date: nil)
                              .where("end_date < ?", today)
                              .order(end_date: :desc, name: :asc)

    @undated_courses = current_user.courses.where(start_date: nil)
                                 .or(current_user.courses.where(end_date: nil))
                                 .order(:name)

    render({ :template => "course_templates/index" })
  end

  def show
    matching_courses = current_user.courses

    @the_course = current_user.courses.where(id: params.fetch("path_id")).first
    @upcoming_tasks = @the_course.tasks.where.not(status: "completed").order(:due_date, :due_time)

    render({ :template => "course_templates/show" })
  end

  def create
    the_course = Course.new
    the_course.name = params.fetch("query_name")
    the_course.user = current_user #params.fetch("query_user_id")
    the_course.location = params.fetch("query_location")
    the_course.meeting_time = params.fetch("query_meeting_time")
    the_course.instructor_name = params.fetch("query_instructor_name")
    the_course.instructor_email = params.fetch("query_instructor_email")
    the_course.color = params.fetch("query_color")
    the_course.meeting_days = params.fetch("query_meeting_days", []).join(", ")
    the_course.start_date = params.fetch("query_start_date")
    the_course.end_date = params.fetch("query_end_date")

    if the_course.valid?
      the_course.save
      redirect_to("/courses", { :notice => "Course created successfully." })
    else
      redirect_to("/courses", { :alert => the_course.errors.full_messages.to_sentence })
    end
  end

  def update
    the_course = current_user.courses.where(id: params.fetch("path_id")).first

    the_course.name = params.fetch("query_name")
    the_course.user = current_user #params.fetch("query_user_id")
    the_course.location = params.fetch("query_location")
    the_course.meeting_time = params.fetch("query_meeting_time")
    the_course.instructor_name = params.fetch("query_instructor_name")
    the_course.instructor_email = params.fetch("query_instructor_email")
    the_course.color = params.fetch("query_color")
    the_course.meeting_days = params.fetch("query_meeting_days", []).join(", ") # join multiple days into one string
    the_course.start_date = params.fetch("query_start_date")
    the_course.end_date = params.fetch("query_end_date")


    if the_course.valid?
      the_course.save
      redirect_to("/courses/#{the_course.id}", { :notice => "Course updated successfully." } )
    else
      redirect_to("/courses/#{the_course.id}", { :alert => the_course.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_course = Course.where({ :id => the_id }).at(0)

    the_course.destroy

    redirect_to("/courses", { :notice => "Course deleted successfully." } )
  end
end
