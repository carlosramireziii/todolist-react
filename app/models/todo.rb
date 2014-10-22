class Todo < Base
  attr_accessor :list_id
  attr_accessor :title, :finished

  def list
    List.find(list_id)
  end

  # ensure that value is returned as boolean
  def finished
    @finished.to_s == 'true'
  end
end
