(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var addUser, receiveMsg, removeUser, socketClient, userList, userLoignMsg;

socketClient = io();

userList = {};

$('.login-out').click(function() {
  return window.location.href = '/';
});

$('#login-form').submit(function() {
  socketClient.emit('user login', $('#user-name').val());
  return false;
});

userLoignMsg = function(userMsg) {
  var html;
  console.log(userMsg);
  userList = userMsg.userList;
  console.log(userList);
  html = "当前在线人数:<span class='red'>" + userMsg.userCount + "</span>";
  $('.chat-status').html(html);
  html = "<div class='welcome'>欢迎<span class='red' data-user='" + userMsg.userName + "'>" + userMsg.userName + "</span>加入聊天</div>";
  addUser(userMsg);
  if (userMsg.userName == null) {
    return;
  }
  if (userMsg.userLeft != null) {
    removeUser(userMsg);
    html = "<div class='welcome'><span class='red'>" + userMsg.userName + "</span>退出群聊</div>";
  }
  return $('.message-list').append(html);
};

addUser = function(userMsg) {
  var html, user;
  html = "<li class='all'>所有人(默认群聊)</li>";
  for (user in userMsg.userList) {
    html += "<li>" + user + "</li>";
  }
  return $('.user-ul').html(html);
};

removeUser = function(userMsg) {
  var j, key, len, ref, results, user;
  $('.user-ul li').each(function(i, n) {
    var value;
    value = $(this).attr('data-user');
    if (value === userMsg.userName) {
      return $('.user-ul li').eq(i).remove();
    }
  });
  ref = userMsg.userList;
  results = [];
  for (key = j = 0, len = ref.length; j < len; key = ++j) {
    user = ref[key];
    if (user === userMsg.userName) {
      delete userMsg.userList[key];
      $('user-ul').find('li').eq(key).remove();
      break;
    } else {
      results.push(void 0);
    }
  }
  return results;
};

socketClient.on('user logined', function(userMsg) {
  $('.user-login').remove();
  return userLoignMsg(userMsg);
});

socketClient.on('user loginOut', function(userMsg) {
  return userLoignMsg(userMsg);
});

$('#message-form').submit(function() {
  var msg;
  console.log($('#message').val());
  msg = $('#message').val();
  socketClient.emit('onMessage', msg);
  return false;
});

receiveMsg = function(dom, data) {
  var html;
  html = "<div class='messages'> <div class='user-" + dom + "'>" + data.userName + "</div> <div class='" + dom + "'> " + data.msg + " <div class='" + dom + "-circle'></div> </div> </div>";
  return $('.message-list').append(html);
};

socketClient.on('my message', function(data) {
  return receiveMsg('my-message', data);
});

socketClient.on('others message', function(data) {
  return receiveMsg('others-message', data);
});

module.exports = console.log('ddaaaaaaaaaaaa');

},{}]},{},[1]);
