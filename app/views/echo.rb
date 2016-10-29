<!doctype html>
<html>
  <head>
    <title>Echo</title>
  </head>
  <body>
    <h1> Echo  Sinatra server </h1>
	Last refresh: <%=Time.new%>
    <ul>
      <% data.each do |group,map| %>
      <li><strong><%= group.capitalize %></strong>:
        <ul>
        <% map.each do |k,v| %>
          <li><%= k %>: <%= v %></li>
        <% end %>
        </ul>
      </li>
      <% end %>
    </ul>
  </body>
</html>
