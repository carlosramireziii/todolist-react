class TodosController < ApplicationController
  respond_to :html, only: [:create]
  respond_to :json

  before_action :set_list

  def index
    respond_with @list.todos
  end

  def create
    respond_with @list, Todo.create(todo_params_with_list), location: @list
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def todo_params
    params.require(:todo).permit(:title)
  end

  # needed for cache persistence
  def todo_params_with_list
    todo_params.merge(list_id: @list.id)
  end
end
