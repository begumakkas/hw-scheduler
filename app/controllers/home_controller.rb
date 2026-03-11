class HomeController < ApplicationController
  def index
    @tasks = Task.order(:due_date, :due_time)
    
    render({ :template => "home_templates/index" })
  end
end
