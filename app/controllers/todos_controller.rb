class TodosController < ApplicationController
  respond_to :html, only: [:create]
  respond_to :json

  before_action :set_list, except: [:update]
  before_action :set_todo, only: [:update]

  def index
    respond_with @list.todos
  end

  def create
    respond_with Todo.create(todo_params_with_list), location: @list
  end

  def update
    # http://stackoverflow.com/questions/14496747/put-requests-in-rails-dont-update-the-status-on-respond-with-calls
    # http://vombat.tumblr.com/post/8191942021/responding-with-non-empty-json-when-updating-a-resource
    respond_with @todo.update(todo_params) do |format|
      format.json {
        if @todo.valid?
          render json: @todo
        else
          render json: @todo.errors, status: :unprocessable_entity
        end
      }
    end
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :finished)
  end

  # needed for cache persistence
  def todo_params_with_list
    todo_params.merge(list_id: @list.id)
  end
end
