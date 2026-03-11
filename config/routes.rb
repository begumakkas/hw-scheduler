Rails.application.routes.draw do
  get("/", { :controller => "syllabis", :action => ""})

  # Routes for the Syllabi resource:

  # CREATE
  post("/insert_syllabi", { :controller => "syllabis", :action => "create" })

  # READ
  get("/syllabis", { :controller => "syllabis", :action => "index" })

  get("/syllabis/:path_id", { :controller => "syllabis", :action => "show" })

  # UPDATE

  post("/modify_syllabi/:path_id", { :controller => "syllabis", :action => "update" })

  # DELETE
  get("/delete_syllabi/:path_id", { :controller => "syllabis", :action => "destroy" })

  #------------------------------

  # Routes for the Policy resource:

  # CREATE
  post("/insert_policy", { :controller => "policies", :action => "create" })

  # READ
  get("/policies", { :controller => "policies", :action => "index" })

  get("/policies/:path_id", { :controller => "policies", :action => "show" })

  # UPDATE

  post("/modify_policy/:path_id", { :controller => "policies", :action => "update" })

  # DELETE
  get("/delete_policy/:path_id", { :controller => "policies", :action => "destroy" })

  #------------------------------

  devise_for :users
  # Routes for the Course resource:

  # CREATE
  post("/insert_course", { :controller => "courses", :action => "create" })

  # READ
  get("/courses", { :controller => "courses", :action => "index" })

  get("/courses/:path_id", { :controller => "courses", :action => "show" })

  # UPDATE

  post("/modify_course/:path_id", { :controller => "courses", :action => "update" })

  # DELETE
  get("/delete_course/:path_id", { :controller => "courses", :action => "destroy" })

  #------------------------------

  # Routes for the Task resource:

  # CREATE
  post("/insert_task", { :controller => "tasks", :action => "create" })

  # READ
  get("/tasks", { :controller => "tasks", :action => "index" })

  get("/tasks/:path_id", { :controller => "tasks", :action => "show" })

  # UPDATE

  post("/modify_task/:path_id", { :controller => "tasks", :action => "update" })

  # DELETE
  get("/delete_task/:path_id", { :controller => "tasks", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
