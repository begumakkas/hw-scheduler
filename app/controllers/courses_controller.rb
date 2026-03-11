class CoursesController < ApplicationController
  def index
    matching_courses = Course.all

    @list_of_courses = matching_courses.order({ :created_at => :desc })
    @the_course = matching_courses.at(0)

    render({ :template => "course_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_courses = Course.where({ :id => the_id })

    @the_course = matching_courses.at(0)

    render({ :template => "course_templates/show" })
  end

  def create
    the_course = Course.new
    the_course.name = params.fetch("query_name")
    the_course.user_id = params.fetch("query_user_id")
    the_course.location = params.fetch("query_location")
    the_course.meeting_time = params.fetch("query_meeting_time")
    the_course.instructor_name = params.fetch("query_instructor_name")
    the_course.instructor_email = params.fetch("query_instructor_email")
    the_course.color = params.fetch("query_color")
    the_course.meeting_days = params.fetch("query_meeting_days", []).join(", ")

    if the_course.valid?
      the_course.save
      redirect_to("/courses", { :notice => "Course created successfully." })
    else
      redirect_to("/courses", { :alert => the_course.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_course = Course.where({ :id => the_id }).at(0)

    the_course.name = params.fetch("query_name")
    the_course.user_id = params.fetch("query_user_id")
    the_course.location = params.fetch("query_location")
    the_course.meeting_time = params.fetch("query_meeting_time")
    the_course.instructor_name = params.fetch("query_instructor_name")
    the_course.instructor_email = params.fetch("query_instructor_email")
    the_course.color = params.fetch("query_color")
    the_course.meeting_days = params.fetch("query_meeting_days", []).join(", ") # join multiple days into one string

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
