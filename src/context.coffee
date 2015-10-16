validate = require('json-schema').validate
assert = require 'assert'
Promise = require 'bluebird'
needle = Promise.promisifyAll(require('needle'))


schema_kaspersky = require('./schema').kaspersky

getPromise = ->
    return new Promise (resolve, reject) ->
        resolve()

PutConfig = (baseUrl,id,config)->
    needle.putAsync baseUrl + "/corenova/#{id}/transform/include", config, json:true
    .then (resp) =>
        throw new Error 'invalidStatusCode' unless resp[0].statusCode is 200                        
        #server.history.config = utils.extend {},server.config
        return config
    .catch (err) =>
        throw err


Start =  (context) ->
    throw new Error 'openvpn-storm.Start missingParams' unless context.bInstalledPackages and context.service.name and context.service.config
    config = context.service.config
    #forcefully set the start flag to true 
    config.HAVE_KASPERSKY = true
    id = "500eb587-2731-493a-8afa-ffcefee3bee2"    
    getPromise()
    .then (resp) =>        
        return PutConfig(context.baseUrl,id,config)    
    .then (resp) =>
        console.log resp
        return context
    .catch (err) =>
        throw err


Stop =  (context) ->
    throw new Error 'openvpn-storm.Start missingParams' unless context.bInstalledPackages and context.service.name and context.service.config
    config = context.service.config
    #forcefully set the start flag to true 
    config.HAVE_KASPERSKY = false
    id = "500eb587-2731-493a-8afa-ffcefee3bee2"    
    getPromise()
    .then (resp) =>        
        return PutConfig(context.baseUrl,id,config)    
    .then (resp) =>
        console.log resp
        return context
    .catch (err) =>
        throw err

Update =  (context) ->
    throw new Error 'openvpn-storm.Start missingParams' unless context.bInstalledPackages and context.service.name and context.service.config
    config = context.service.config
    id = "500eb587-2731-493a-8afa-ffcefee3bee2"    
    getPromise()
    .then (resp) =>        
        return PutConfig(context.baseUrl,id,config)    
    .then (resp) =>
        console.log resp
        return context
    .catch (err) =>
        throw err

###
#input to the validate is  { config:{}}
Validate =  (config) ->
    throw new Error "openvpn.Validate - invalid input" unless config.servers? and config.clients?
    for server in config.servers
        chk = validate server.config, schema['server']        
        console.log 'server validate result ', chk
        unless chk.valid
            throw new Error "server schema check failed"+  chk.valid
            return  false
        if server.users?
            for user in server.users 
                chk = validate user, schema['user']        
                console.log 'user validate result ', chk
                unless chk.valid
                    throw new Error "user schema check failed"+  chk.valid
                    return  false

    for client in config.clients
        chk = validate client.config, schema['client']        
        console.log 'client validate result ', chk
        unless chk.valid
            throw new Error "client schema check failed"+  chk.valid
            return  false

    return true
###

module.exports.start = Start
module.exports.stop = Stop
module.exports.update = Update
#module.exports.validate = Validate