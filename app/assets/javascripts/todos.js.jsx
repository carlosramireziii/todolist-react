/** @jsx React.DOM */

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