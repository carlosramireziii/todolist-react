module ListsHelper
  def render_todo(todo)
    if todo.finished
      content_tag(:s, todo.title)
    else
      todo.title
    end
  end
end
