jsonfile = require('jsonfile')
Start = require('./../src/context').start
Stop = require('./../src/context').stop
Update = require('./../src/context').update
#Validate = require('./../src/context').validate
Promise = require 'bluebird'
context = {}


input = 
	{
    	"baseUrl": "http://192.168.122.217:5000",
    	"bInstalledPackages": true,
    	"bFactoryPush": false,
    	"service":{
        	"name": "kaspersky",
        	"config": {}
            }
	}



getPromise = ->
	return new Promise (resolve, reject) ->
		resolve()

startcall = (input)->
	getPromise()
	.then (resp) =>
		jsonfile.writeFileSync("/tmp/start-input.json",input,{spaces: 2})
		return Start input
	.catch (err) =>
		console.log "Start err ", err
	.then (resp) =>
		jsonfile.writeFileSync("/tmp/start-output.json",resp,{spaces: 2})
		console.log "result from Start:\n ", JSON.stringify resp
	.done

#test1
kavconfig =
	"KASPERSKY_SCAN_TIMEOUT": 20000
	"KASPERSKY_MAX_SESSIONS": 10
	"HTTP_AV_SCAN" : false
	"KASPERSKY_HTTP_UPLOAD" : false
	"KASPERSKY_HTTP_DOWNLOAD" : false
	"MAIL_AV_SCAN" : false
	"KASPERSKY_SMTP" : false
	"KASPERSKY_POP3" : false
	"KASPERSKY_IMAP" : false

input.service.config = kavconfig
startcall(input)


