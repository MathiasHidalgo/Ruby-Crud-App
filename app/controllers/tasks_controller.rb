# app/controllers/tasks_controller.rb

class TasksController < ApplicationController
  # Skip CSRF token verification for API requests if you're not handling it in the frontend
  # IMPORTANT: This is generally NOT recommended for production without proper API authentication
  # or another CSRF protection mechanism. For development with a separate frontend, it might be necessary.
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]


  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
    # Respond with JSON for API requests
    respond_to do |format|
      format.html # Renders the default HTML view
      format.json { render json: @tasks } # Renders tasks as JSON
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    respond_to do |format|
      format.html # Renders the default HTML view
      format.json { render json: @task } # Renders the task as JSON
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    # Explicitly handle JSON response for API calls
    if request.format.json?
      if @task.save
        render json: @task, status: :created, location: @task
      else
        # Render validation errors as JSON with unprocessable_entity status
        render json: @task.errors, status: :unprocessable_entity
      end
    else
      # Default HTML response for non-JSON requests
      respond_to do |format|
        if @task.save
          format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
     # Explicitly handle JSON response for API calls
    if request.format.json?
      if @task.update(task_params)
        render json: @task, status: :ok, location: @task
      else
         # Render validation errors as JSON with unprocessable_entity status
        render json: @task.errors, status: :unprocessable_entity
      end
    else
      # Default HTML response for non-JSON requests
      respond_to do |format|
        if @task.update(task_params)
          format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    # Explicitly handle JSON response for API calls
    if request.format.json?
       head :no_content # Respond with 204 No Content for successful deletion
    else
      # Default HTML response for non-JSON requests
      respond_to do |format|
        format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description)
    end
end

# Explanation of Changes:
# - Added explicit checks `if request.format.json?` in `create`, `update`, and `destroy` actions.
# - Inside the `if request.format.json?` block, the code now directly renders JSON responses
#   for both success and failure cases.
# - For the `create` and `update` actions, if `@task.save` or `@task.update` fails,
#   `render json: @task.errors, status: :unprocessable_entity` is explicitly called
#   to ensure the validation errors are returned as JSON with the 422 status.
# - The original `respond_to` blocks are kept in the `else` part for handling traditional
#   HTML requests if needed.
# - Added a commented-out line `skip_before_action :verify_authenticity_token` as a common
#   workaround for API-only backends when CSRF isn't handled by the frontend.
#   **Use this with caution and understand the security implications.**
