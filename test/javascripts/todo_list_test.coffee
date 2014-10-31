TU = React.addons.TestUtils

QUnit.test 'renders component', (assert) -> 
  list = TU.renderIntoDocument new TodoList(data: [])
  assert.ok TU.findRenderedComponentWithType(list, TodoList), 'expected to render a TodoList'

QUnit.test 'renders a todo component for each item in collection', (assert) -> 
  todos = [
    { title: 'completed todo', finished: true },
    { title: 'not finished todo', finished: false }
  ]
  list = TU.renderIntoDocument new TodoList(data: todos)
  result = TU.scryRenderedComponentsWithType list, Todo
  assert.equal result.length, 2