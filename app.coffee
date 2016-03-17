express = require('express');
app = express()
server = require('http').createServer(app)
socketIo = require('socket.io')(server)

app.use(express.static(__dirname + '/client/dist'))

userCount = 0
hasUserLogin = false
userList = {}

# This is for public chat
# app.get '/', (req, res)->
# 	res.sendFile __dirname + '/client/index.html'

# socketIo.on 'connection', (socket)->
# 	console.log 'i connected.....'

# 	#user login
# 	socket.on 'user login', (userName)->
# 		userCount++
# 		hasUserLogin = true
# 		socket.username = userName  #声明赋值
# 		userList[socket.username] = userName
# 		userMsg = {
# 			userCount: userCount
# 			userName: userName
# 			userList: userList
# 		}
# 		socket.emit 'user logined', userMsg  #首先通知自己
# 		socket.broadcast.emit 'user logined', userMsg  #然后通知其他连接的用户

# 	socket.on 'disconnect', ()->
# 		if hasUserLogin is true
# 			userCount--
# 			delete userList[socket.username]
# 			userMsg = {
# 				userLeft: 'loginOut'
# 				userCount: userCount
# 				userName: socket.username
# 				userList: userList
# 			}
# 			socket.broadcast.emit 'user loginOut', userMsg
# 			console.log 'user disconnected'

# 	# receive users'messages
# 	socket.on 'onMessage', (msg)->
# 		data = {
# 			userName: socket.username  #自动判别是谁发出的
# 			msg: msg
# 			userList: userList
# 		}
# 		#向自己发送聊天消息
# 		socket.emit 'my message', data  
# 		#broadcast   ---->   向所有的连接触发事件，这里注意：不包括本身连接的事件。
# 		socket.broadcast.emit 'others message', data

# This is for public chat and private chat
app.get '/', (req, res)->
	res.sendFile __dirname + '/client/private.html'

socketIo.on 'connection', (socket)->
	console.log 'i connected.....'

	#user login
	socket.on 'user login', (userName)->
		userCount++
		hasUserLogin = true
		socket.username = userName  #声明赋值
		userList[socket.username] = userName
		userMsg = {
			userCount: userCount
			userName: userName
			userList: userList
		}
		socket.emit 'user logined', userMsg  #首先通知自己
		socket.broadcast.emit 'user logined', userMsg  #然后通知其他连接的用户

	socket.on 'disconnect', ()->
		if hasUserLogin is true
			userCount--
			delete userList[socket.username]
			userMsg = {
				userLeft: 'loginOut'
				userCount: userCount
				userName: socket.username
				userList: userList
			}
			socket.broadcast.emit 'user loginOut', userMsg
			console.log 'user disconnected'

	# receive users'messages
	socket.on 'onMessage', (msg)->
		data = {
			userName: socket.username  #自动判别是谁发出的
			msg: msg
			userList: userList
		}
		#向自己发送聊天消息
		socket.emit 'my message', data  
		#broadcast   ---->   向所有的连接触发事件，这里注意：不包括本身连接的事件。
		socket.broadcast.emit 'others message', data

server.listen 3000, ()->
	console.log 'listening on *:3000....'
