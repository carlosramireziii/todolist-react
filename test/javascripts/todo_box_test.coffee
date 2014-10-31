TU = React.addons.TestUtils

QUnit.test 'renders component', (assert) -> 
  box = TU.renderIntoDocument new TodoBox()
  assert.ok TU.findRenderedComponentWithType(box, TodoBox), 'expected to render a TodoBox'

QUnit.test 'renders form and list components', (assert) ->
  box = TU.renderIntoDocument new TodoBox()
  assert.ok TU.findRenderedComponentWithType(box, TodoForm), 'expected to render a TodoForm'
  assert.ok TU.findRenderedComponentWithType(box, TodoList), 'expected to render a TodoList'

QUnit.test 'fetches todos from server when mounted', (assert) ->
  todos = [
    { title: 'completed todo', finished: true },
    { title: 'not finished todo', finished: false }
  ]
  $.ajax = (options) ->
    options.success todos

  box = TU.renderIntoDocument new TodoBox()
  assert.equal box.state.data, todos

# TODO: need a real way to mock out these AJAX calls

# QUnit.test 'adds new todo on submit', (assert) ->
#   # overriding the AJAX here is a little tricky since there are multiple calls being made
#   $.ajax = (options) ->
#     options.success []

#   box = TU.renderIntoDocument new TodoBox()

#   todo = { title: 'new todo', finished: false }
#   $.ajax = (options) ->
#     console.debug options
#     options.success [todo]

#   box.handleTodoSubmit todo
#   #console.debug box
#   assert.equal box.state.data, [todo]