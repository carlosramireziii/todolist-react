class Todo < Base
  attr_accessor :list_id
  attr_accessor :title, :finished

  def list
    List.find(list_id)
  end
end
