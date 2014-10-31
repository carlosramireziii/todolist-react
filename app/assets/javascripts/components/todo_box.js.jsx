/** @jsx React.DOM */

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
    this.setState({data: todos}, function() {
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