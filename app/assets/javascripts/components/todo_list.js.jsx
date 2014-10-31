/** @jsx React.DOM */

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