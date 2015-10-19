jsonfile = require('jsonfile')
Start = require('./../src/context').start
Stop = require('./../src/context').stop
Update = require('./../src/context').update
Validate = require('./../src/context').validate
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
		jsonfile.writeFileSync("/tmp/kss-start-input.json",input,{spaces: 2})
		return Start input
	.catch (err) =>
		console.log "Start err ", err
	.then (resp) =>
		jsonfile.writeFileSync("/tmp/kss-start-output.json",resp,{spaces: 2})
		console.log "result from Start:\n ", JSON.stringify resp
	.done


stopcall = (input)->
	getPromise()
	.then (resp) =>
		jsonfile.writeFileSync("/tmp/kss-stop-input.json",input,{spaces: 2})
		return Stop input
	.catch (err) =>
		console.log "Stop err ", err
	.then (resp) =>
		jsonfile.writeFileSync("/tmp/kss-stop-output.json",resp,{spaces: 2})
		console.log "result from Stop:\n ", JSON.stringify resp
	.done


updatecall = (input)->
	getPromise()
	.then (resp) =>
		input.service.config.HTTP_AV_SCAN = true
		input.service.config.KASPERSKY_HTTP_UPLOAD = true
		input.service.config.KASPERSKY_HTTP_DOWNLOAD = true
		jsonfile.writeFileSync("/tmp/kss-update-input.json",input,{spaces: 2})
		return Update input
	.catch (err) =>
		console.log "Update err ", err
	.then (resp) =>
		jsonfile.writeFileSync("/tmp/kss-update-output.json",resp,{spaces: 2})
		console.log "result from Update:\n ", JSON.stringify resp
	.done








#test routine
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
	"HTTP_VIRUS_TEMPLATE" : 
		"filename" : "template.virus"
		"encoding" : "base64"
		"data" : "dGVtcGxhdGUudmlydXMgY29udGVudA=="
#kav1config = {}
input.service.config = kavconfig
startcall(input)
setTimeout(updatecall,30000,input)
setTimeout(stopcall,60000,input)

###
config = {}
result = Validate(config)
console.log "Validate output ", result
###