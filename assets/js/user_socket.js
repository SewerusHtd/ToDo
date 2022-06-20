// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"
import makeRemote from "./ajax";
window.makeRemote = makeRemote;

// And connect to the path in "lib/todo_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {params: {token: window.userToken}})
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/todo_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/todo_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/todo_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
// let channel = socket.channel("room:42", {})
// channel.join()
//   .receive("ok", resp => { console.log("Joined successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join", resp) })

// CHANNELS functions

function prepareItem(item) {
    return `<div id='item_${item.id}' class='moving-item moving-item-${(item.id % 4) + 1 }'>\n` +
        `    <div class='item incompleted' style='animation-duration: ${Math.floor(Math.random() * 30) + 15}s, ${Math.floor(Math.random() * 30) + 15}s;'>\n` +
        `        <h3>${item.description}</h3>\n` +
        "            <div class='items-links'>\n" +
        "                <span class='completed-link'>\n" +
        `                    <a href="/items/${item.id}/complete" data-method="patch" data-to="/items/${item.id}/complete" data-remote="true" data-csrf="${csrfToken}">Mark as completed</a> |\n` +
        "                </span>\n" +
        `                <a href="/items/${item.id}" data-method="delete" data-to="/items/${item.id}" data-remote="true" data-csrf="${csrfToken}">Delete</a>\n` +
        "            </div>\n" +
        "    </div>\n" +
        "</div>"
}

function prepareProject(project) {
    return `<div id='project_${project.id}' class='moving-project moving-project-${(project.id % 4) + 1 }'>\n` +
        `    <a href="/projects/${project.id}" class='project' style='animation-duration: ${Math.floor(Math.random() * 30) + 15}s, ${Math.floor(Math.random() * 30) + 15}s; box-shadow: 0 0 15px ${project.color};'>\n` +
        `        <h3>${project.title}</h3>\n` +
        "    </a>\n" +
        "</div>"
}

// ITEMS CHANNEL

let channel = socket.channel("items:lobby", {})
if($("#all-tasks-title").length > 0) {
    channel.join()
        .receive("ok", resp => { console.log("Items joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("destroy_item", item => {
        console.log("Destroyed item of id " + item.id);
        $("#item_" + item.id).fadeOut();
    })

    channel.on("complete_item", item => {
        console.log("Completed item of id " + item.id);
        const item_wrapper = $("#item_" + item.id);
        item_wrapper.find(".item").css("box-shadow", "0 0 15px lightgreen");
        item_wrapper.find(".completed-link").hide();
    })

    channel.on("create_item", item => {
        console.log("Created item of id " + item.id);
        $("#item_description").val("");
        $("#items-container").append(prepareItem(item));
        makeRemote();
    })
}

// PROJECTS CHANNEL

// import { projectsDelete } from './phoenix-jsroutes';

if($("#projects-container").length > 0) {
    channel = socket.channel("projects:lobby", {})
    channel.join()
        .receive("ok", resp => {
            console.log("Projects joined successfully", resp)
        })
        .receive("error", resp => {
            console.log("Unable to join", resp)
        })

    channel.on("create_project", project => {
        console.log("Created project of id " + project.id);
        $("#projects-container").append(prepareProject(project));
        makeRemote();
    })

    channel.on("update_project", project => {
        console.log("Updated project of id " + project.id);
        $(`#project_${project.id}`).replaceWith(prepareProject(project));
        makeRemote();
    })

    channel.on("destroy_project", project => {
        console.log("Destroyed project of id " + project.id);
        $("#project_" + project.id).fadeOut();
    })
}

// PROJECTS CHANNEL

if($("#project-title").length > 0) {
    let project_id = $("#project-title").data()['id']
    channel = socket.channel(`items:${project_id}`, {})
    channel.join()
        .receive("ok", resp => { console.log("Project's items joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("create_item", item => {
        console.log("Created item of id " + item.id);
        $("#item_description").val("");
        $("#items-container").append(prepareItem(item));
        makeRemote();
    })

    channel.on("complete_item", item => {
        console.log("Completed item of id " + item.id);
        const item_wrapper = $("#item_" + item.id);
        item_wrapper.find(".item").css("box-shadow", "0 0 15px lightgreen");
        item_wrapper.find(".completed-link").hide();
    })

    channel.on("destroy_item", item => {
        console.log("Destroyed item of id " + item.id);
        $("#item_" + item.id).fadeOut();
    })
}

export default socket
