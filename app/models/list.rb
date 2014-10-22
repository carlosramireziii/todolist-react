class List < Base
  attr_accessor :name

  def todos
    Todo.where(list_id: id)
  end
end
