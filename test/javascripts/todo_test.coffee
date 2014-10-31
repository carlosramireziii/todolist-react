TU = React.addons.TestUtils

QUnit.test 'renders component', (assert) -> 
  todo = TU.renderIntoDocument new Todo()
  assert.ok TU.findRenderedComponentWithType(todo, Todo), 'expected to render a Todo'

QUnit.test 'sets initial checkbox state', (assert) -> 
  unfinished_todo = TU.renderIntoDocument new Todo(initialFinished: false)
  input = TU.findRenderedDOMComponentWithTag unfinished_todo, 'input'
  assert.equal input.props.checked, false, 'expected checkbox to be unchecked'

  finished_todo = TU.renderIntoDocument new Todo(initialFinished: true)
  input = TU.findRenderedDOMComponentWithTag finished_todo, 'input'
  assert.ok input.props.checked, 'expected checkbox to be checked'

QUnit.test 'sets class for finished todos', (assert) ->
  unfinished_todo = TU.renderIntoDocument new Todo(initialFinished: false)
  span = TU.findRenderedDOMComponentWithTag unfinished_todo, 'span'
  assert.notEqual span.props.className, 'finished', 'did not expect class to be present'

  finished_todo = TU.renderIntoDocument new Todo(initialFinished: true)
  span = TU.findRenderedDOMComponentWithTag finished_todo, 'span'
  assert.equal span.props.className, 'finished', 'expected class to be present'

QUnit.test 'displays title', (assert) -> 
  title = 'test title'
  todo = TU.renderIntoDocument new Todo(children: title)
  span = TU.findRenderedDOMComponentWithTag todo, 'span'
  assert.equal span.props.children, title

QUnit.test 'changes the finished state after click', (assert) ->
  # mock the AJAX call
  $.ajax = (options) ->
    options.success finished: true

  todo = TU.renderIntoDocument new Todo(initialFinished: false)
  input = TU.findRenderedDOMComponentWithTag todo, 'input'
  assert.equal input.props.checked, false, 'expected checkbox to be unchecked'
  TU.Simulate.change input
  assert.ok input.props.checked, 'expected checkbox to be checked after changed'