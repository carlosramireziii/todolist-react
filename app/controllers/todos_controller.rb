class TodosController < ApplicationController
  respond_to :json

  before_action :set_list

  def index
    respond_with @list.todos
  end

  def create
    respond_with @list.create(todo_params)
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def todo_params
    params.require(:todo).permit(:title, :finished)
  end
end
