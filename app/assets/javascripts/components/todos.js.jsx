/** @jsx React.DOM */
var Todo = React.createClass({
  getInitialState: function() {
    return { finished: this.props.initialFinished };
  },
  handleChanged: function(event) {
    this.handleTodoChanged({id: this.props.id, finished: event.target.checked});
    return;
  },
  // QUESTION: Which component should store the callback for updating the todo item?
  handleTodoChanged: function(todo) {
    this.setState({finished: todo.finished}, function() {
      var url = '/todos/' + todo.id + '.json';
      $.ajax({
        url: url,
        dataType: 'json',
        type: 'PATCH',
        data: {'todo': {finished: todo.finished}},
        success: function(data) {
          this.setState({finished: data.finished});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
      });
    });
  },
  render: function() {
    var css = (this.state.finished) ? 'finished' : '';
    return (
      <li>
        <input type="checkbox" checked={this.state.finished} onChange={this.handleChanged}/>
        <span className={css}>{this.props.children}</span>
      </li>
    );
  }
});

var TodoBox = React.createClass({
  loadTodosFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  handleTodoSubmit: function(todo) {
    var todos = this.state.data;
    todos.push(todo);
    this.setState({todos: todos}, function() {
      $.ajax({
        url: this.props.url,
        dataType: 'json',
        type: 'POST',
        data: {'todo': todo},
        success: function(data) {
          this.loadTodosFromServer();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
      });
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  componentDidMount: function() {
    this.loadTodosFromServer();
  },
  render: function() {
    return (
      <div className="todoBox">
        <TodoForm onTodoSubmit={this.handleTodoSubmit}/>
        <TodoList data={this.state.data} />
      </div>
    );
  }
});

var TodoList = React.createClass({
  render: function() {
    var todoNodes = this.props.data.map(function(todo, index) {
      return (
        <Todo id={todo.id} initialFinished={todo.finished} key={index}>
          {todo.title}
        </Todo>
      );
    });
    return (
      <ul className="todoList">
        {todoNodes}
      </ul>
    );
  }
});

var TodoForm = React.createClass({
  handleSubmit: function(e) {
    e.preventDefault();
    var title = this.refs.title.getDOMNode().value.trim();
    if (!title) {
      return;
    }
    this.props.onTodoSubmit({title: title});
    this.refs.title.getDOMNode().value = '';
    return;
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

var ready = function() {
  var root = document.getElementById('todos');
  var list_id = root.getAttribute('data-list-id');
  var url = "/lists/" + list_id + "/todos.json";

  React.renderComponent(
    <TodoBox url={url} />,
    root
  );
};

$(document).ready(ready);