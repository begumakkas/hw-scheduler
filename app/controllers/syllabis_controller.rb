class SyllabisController < ApplicationController
  def index
    matching_syllabis = Syllabi.all

    @list_of_syllabis = matching_syllabis.order({ :created_at => :desc })

    render({ :template => "syllabi_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_syllabis = Syllabi.where({ :id => the_id })

    @the_syllabi = matching_syllabis.at(0)

    render({ :template => "syllabi_templates/show" })
  end

  def create
    the_syllabi = Syllabi.new
    the_syllabi.user_id = params.fetch("query_user_id")
    the_syllabi.course_id = params.fetch("query_course_id")
    the_syllabi.file_name = params.fetch("query_file_name")
    the_syllabi.raw_extracted_json = params.fetch("query_raw_extracted_json")
    the_syllabi.file_url = params.fetch("query_file_url")

    if the_syllabi.valid?
      the_syllabi.save
      redirect_to("/syllabis", { :notice => "Syllabi created successfully." })
    else
      redirect_to("/syllabis", { :alert => the_syllabi.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_syllabi = Syllabi.where({ :id => the_id }).at(0)

    the_syllabi.user_id = params.fetch("query_user_id")
    the_syllabi.course_id = params.fetch("query_course_id")
    the_syllabi.file_name = params.fetch("query_file_name")
    the_syllabi.raw_extracted_json = params.fetch("query_raw_extracted_json")
    the_syllabi.file_url = params.fetch("query_file_url")

    if the_syllabi.valid?
      the_syllabi.save
      redirect_to("/syllabis/#{the_syllabi.id}", { :notice => "Syllabi updated successfully." } )
    else
      redirect_to("/syllabis/#{the_syllabi.id}", { :alert => the_syllabi.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_syllabi = Syllabi.where({ :id => the_id }).at(0)

    the_syllabi.destroy

    redirect_to("/syllabis", { :notice => "Syllabi deleted successfully." } )
  end

  def upload
    uploaded_file = params[:pdf]

    parsed_data = SyllabusParser.call(
      file_path: uploaded_file.tempfile.path
    )

    course = SyllabusImporter.call(
      user: User.first,
      parsed_data: parsed_data,
      file_name: uploaded_file.original_filename,
      file_url: uploaded_file.original_filename
    )

    redirect_to("/courses/#{course.id}", notice: "Syllabus uploaded successfully.")

  end
end
