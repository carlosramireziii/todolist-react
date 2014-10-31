/** @jsx React.DOM */

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