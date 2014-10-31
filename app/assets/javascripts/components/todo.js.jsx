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