TU = React.addons.TestUtils

QUnit.test 'renders component', (assert) -> 
  form = TU.renderIntoDocument new TodoForm()
  assert.ok TU.findRenderedComponentWithType(form, TodoForm), 'expected to render a TodoForm'

QUnit.test 'clears form after submit', (assert) -> 
  mock_handler = ->
    return

  form = TU.renderIntoDocument new TodoForm(onTodoSubmit: mock_handler)
  form_tag = TU.findRenderedDOMComponentWithTag form, 'form'
  input = form.refs.title
  input.getDOMNode().value = 'New title'
  TU.Simulate.submit form_tag
  assert.equal input.getDOMNode().value, '', 'expected title input field to be cleared after form submit'

QUnit.test 'does not submit todo with no title', (assert) -> 
  mock_handler = ->
    throw 'should not be called'

  form = TU.renderIntoDocument new TodoForm(onTodoSubmit: mock_handler)
  form_tag = TU.findRenderedDOMComponentWithTag form, 'form'
  TU.Simulate.submit form_tag
  expect 0 # if no exception is thrown, then we are good