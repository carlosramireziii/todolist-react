/** @jsx React.DOM */
var Todo = React.createClass({
  render: function () {
    if (this.props.finished) {
      return (
        <li><s>{this.props.title}</s></li>
      );
    }
    else {
      return (
        <li>{this.props.title}</li>
      );
    }
  }
});

var TodoList = React.createClass({
  render: function () {
    var todoNodes = this.props.todos.map(function (todo, index) {
      return (
        <Todo title={todo.title} finished={todo.finished} key={index} />
        );
    });

    return (
      <ul className="todoList">
        {todoNodes}
      </ul>
      );
  }
});

var TodoBox = React.createClass({
  getInitialState: function () {
    return {todos: []};
  },
  componentDidMount: function () {
    this.loadTodosFromServer();
  },
  loadTodosFromServer: function () {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function (todos) {
        this.setState({todos: todos});
      }.bind(this),
      error: function (xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  handleTodoSubmit: function(todo) {
    var todos = this.state.todos;
    var newTodos = todos.concat([todo]);
    this.setState({todos: newTodos});
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'POST',
      data: {"todo": todo},
      success: function(data) {
        this.loadTodosFromServer();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  render: function () {
    return (
      <div className="todoBox">
        <TodoForm onTodoSubmit={this.handleTodoSubmit}/>
        <TodoList todos={this.state.todos} />
      </div>
      );
    }
  });

var TodoForm = React.createClass({
  handleSubmit: function() {
    var title = this.refs.title.getDOMNode().value.trim();
    this.props.onTodoSubmit({title: title});
    this.refs.title.getDOMNode().value = '';
    return false;
  },
  render: function() {
    return (
      <form className="todoForm" onSubmit={this.handleSubmit}>
        <input type="text" placeholder="New todo" ref="title" />
        <input type="submit" value="Create Todo" />
      </form>
      );
  }
});

var ready = function () {
  var root = document.getElementById('todos');
  var list_id = root.getAttribute('data-list-id');
  var url = "/lists/" + list_id + "/todos.json";

  React.renderComponent(
    <TodoBox url={url} />,
    root
  );
};

$(document).ready(ready);