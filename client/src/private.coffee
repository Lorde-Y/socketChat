#socket双向接受， 从客户端发送emit一个事件，后台接收，经过一系列处理（可以判断去到底是谁接收，包括公共聊天和单独聊天），再从后端emit 这个事件发送出去，前台就要接收了

socketClient = io()  #本地引用后就会触发 app.coffee里面的connection

userList = {}

$('.login-out').click ()->
	window.location.href = '/'

# user login
$('#login-form').submit ()->
	socketClient.emit 'user login', $('#user-name').val()
	return false

# user login --loginout
socketClient.on 'user logined', (userMsg)->
	$('.user-login').remove()
	userLoignMsg userMsg

socketClient.on 'user loginOut', (userMsg)->
	userLoignMsg userMsg

userLoignMsg = (userMsg)->
	#用户列表赋值
	console.log userMsg
	userList = userMsg.userList
	console.log userList
	html = "当前在线人数:<span class='red'>#{userMsg.userCount}</span>"
	$('.chat-status').html(html)
	html = "<div class='welcome'>欢迎<span class='red' data-user='#{userMsg.userName}'>#{userMsg.userName}</span>加入聊天</div>"
	addUser userMsg
	if not userMsg.userName?
		return
	if userMsg.userLeft?
		removeUser userMsg
		html = "<div class='welcome'><span class='red'>#{userMsg.userName}</span>退出群聊</div>"
	$('.message-list').append html

addUser = (userMsg)->
	html = "<li class='all active'>所有人(默认群聊)</li>"
	for user of userMsg.userList
		html += "<li>#{user}</li>"
	$('.user-ul').html html

removeUser = (userMsg)->
	$('.user-ul li').each (i,n)->
		value = $(@).attr 'data-user'
		if value is userMsg.userName
			$('.user-ul li').eq(i).remove()

	for user, key in userMsg.userList
		if user is userMsg.userName
			delete userMsg.userList[key]
			$('user-ul').find('li').eq(key).remove()
			break

$(document).on 'click', '.user-ul li', ()->
	$('.user-ul li').removeClass 'active'
	$(@).addClass 'active'

# send public message
$('#message-form').submit ()->
	$dom = $('.user-ul').find('li.active')
	userName = $dom.html()
	console.log $('#message').val()
	msg =  $('#message').val()
	if $dom.hasClass('.all')
		# 群聊
		socketClient.emit 'onMessage', msg
	else
		# 私聊
		socketClient.emit 'to'+userName, msg
	return false

receiveMsg = (dom, data)->
	html = "<div class='messages'>
				<div class='user-#{dom}'>#{data.userName}</div>
				<div class='#{dom}'>
					#{data.msg}
					<div class='#{dom}-circle'></div>
				</div>
			</div>"
	$('.message-list').append html

#收到--后端传回来的--socket事件 立即执行
socketClient.on 'my message', (data)->
	receiveMsg 'my-message', data

socketClient.on 'others message', (data)->
	receiveMsg 'others-message', data

module.exports = console.log('chat with socket')
