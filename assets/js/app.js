// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

import "phoenix_html";
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import "bootstrap";
import _ from "lodash";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import $ from 'jquery'

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

let fullPath = window.location.pathname;
let segPath = fullPath.split('/');
let pageid = segPath.pop();
let taskid = segPath.pop();


function addPadding(number) {
  return (number < 10 ? '0' : '') + number
}

$(document).ready(function() {
  $("#startButton").click(function(event){
    console.log("click start");
    var currentDate = new Date();
    var calendarDate = currentDate.getFullYear() + '-' + addPadding(currentDate.getMonth() + 1) + '-' + addPadding(currentDate.getDate());
    var currentTime = addPadding(currentDate.getHours()) + ":" + addPadding(currentDate.getMinutes()) + ":" + "07Z";
    var concat = calendarDate + "T" + currentTime;

    let text = JSON.stringify({
      start: true,
      id: taskid,
      time: {
        from: concat,
        to: concat,
        task: taskid
      }
    });

    console.log("Starting at time: " + text);

    $.ajax("/ajax/times/" + taskid, {
          method: "PATCH",
          dataType: "json",
          contentType: "application/json; charset=UTF-8",
          data: text,
          success: (resp) => {
          $('#start').val(resp.data.start);
        },
    });

    alert("Time recording has begun and is being recorded in the database, and is now available on the Show Tasks page")

  });

});
$("#stopButton").click(function(event){
  console.log("click stop");
  var currentDate = new Date();
  var calendarDate = currentDate.getFullYear() + '-' + addPadding(currentDate.getMonth() + 1) + '-' + addPadding(currentDate.getDate());
  var currentTime = addPadding(currentDate.getHours()) + ":" + addPadding(currentDate.getMinutes()) + ":" + "07Z";
  var concat = calendarDate + "T" + currentTime;

  let text = JSON.stringify({
    stop: true,
    id: taskid,
    time: {
      from: "",
      to: concat,
      task: taskid
    }
  });

  console.log("Stopping at time: " + text);

  $.ajax("/ajax/times/" + taskid, {
    method: "PATCH",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      $('#stop').val(resp.data.start);
    },
  });

  alert("Time recording has ended and been recorded in the database.")
});

