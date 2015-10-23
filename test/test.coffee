jsonfile = require('jsonfile')
Start = require('./../src/context').start
Stop = require('./../src/context').stop
Update = require('./../src/context').update
Validate = require('./../src/context').validate
Promise = require 'bluebird'
context = {}


input1 = 
	{
    	"baseUrl": "http://192.168.122.217:5000",
    	"bInstalledPackages": true,
    	"bFactoryPush": false,
    	"service":{
        	"name": "kaspersky",
        	"config": {}
            }
	}

input = 
{
	"baseUrl": "http://192.168.122.217:5000",
	"bInstalledPackages": true,
	"bFactoryPush": false,
	"service":{
		"name": "kaspersky",
		"factoryConfig": {
			"config": {
				"kaspersky": {
					"enable": true,
					"coreConfig": {
					}
				}
			}
		}
	}
	"policyConfig": {
		"kaspersky":  {
			"enable": true,
			"coreConfig" : {
			}
		}
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
		input.policyConfig.kaspersky.coreConfig.HTTP_AV_SCAN = true
		input.policyConfig.kaspersky.coreConfig.KASPERSKY_HTTP_UPLOAD = true
		input.policyConfig.kaspersky.coreConfig.KASPERSKY_HTTP_DOWNLOAD = true
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
input.service.factoryConfig.config.kaspersky.coreConfig = kavconfig
startcall(input)
setTimeout(updatecall,30000,input)
setTimeout(stopcall,60000,input)

###
config = {}
result = Validate(config)
console.log "Validate output ", result
###