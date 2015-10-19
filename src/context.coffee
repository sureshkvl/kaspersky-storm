validate = require('json-schema').validate
assert = require 'assert'
Promise = require 'bluebird'
needle = Promise.promisifyAll(require('needle'))

schema_kaspersky = require('./schema').kaspersky

getPromise = ->
    return new Promise (resolve, reject) ->
        resolve()

getCorenovaID = (baseUrl)->
    needle.getAsync baseUrl + "/corenova", json:true
    .then (resp) =>
        throw new Error 'invalidStatusCode' unless resp[0].statusCode is 200
        corenovas = resp[0].body
        #console.log "corenova id is ",corenovas[0].id
        return corenovas[0].id
    .catch (err) =>
        throw err


UpdateKAVRepo = (baseUrl)->    
    config = require('../package.json').config
    kavrepo = config.kav_repo ? "http://repo.dev.intercloud.net/kav"
    data = new Buffer(kavrepo).toString('base64')
    personality = {}; personality.personality = []
    kavpersonality = 
        "path": "/etc/kav_repo",
        "contents": data,
        "postxfer": "/usr/sbin/kav_update"
    personality.personality.push kavpersonality
    #console.log personality
    needle.postAsync baseUrl + "/personality", personality, json:true
    .then (resp) =>
        throw new Error 'invalidStatusCode' unless resp[0].statusCode is 200                        
        return true
    .catch (err) =>
        throw err

PutConfig = (baseUrl,id,config)->
    needle.putAsync baseUrl + "/corenova/#{id}/transform/include", config, json:true
    .then (resp) =>
        throw new Error 'invalidStatusCode' unless resp[0].statusCode is 200                        
        return config
    .catch (err) =>
        throw err


Start =  (context) ->
    throw new Error 'openvpn-storm.Start missingParams' unless context.bInstalledPackages and context.service.name and context.service.config
    config = context.service.config
    #forcefully set the kaspersky flag to true 
    config.HAVE_KASPERSKY = true
    getPromise()
    .then (resp)=>
        return UpdateKAVRepo(context.baseUrl)
    .then (resp) =>
        return getCorenovaID(context.baseUrl)
    .then (corenovaid) =>        
        return PutConfig(context.baseUrl,corenovaid,config)    
    .then (resp) =>
        #console.log resp
        return context
    .catch (err) =>
        throw err


Stop =  (context) ->
    throw new Error 'openvpn-storm.Start missingParams' unless context.bInstalledPackages and context.service.name and context.service.config
    config = context.service.config
    #forcefully set the  kaspersky flag to false
    config.HAVE_KASPERSKY = false   
    getPromise()
    .then (resp) =>    
        return getCorenovaID(context.baseUrl)
    .then (corenovaid) =>     
        return PutConfig(context.baseUrl,corenovaid,config)    
    .then (resp) =>
        #console.log resp
        return context
    .catch (err) =>
        throw err

Update =  (context) ->
    throw new Error 'openvpn-storm.Start missingParams' unless context.bInstalledPackages and context.service.name and context.service.config
    config = context.service.config
    getPromise()
    .then (resp) =>        
        return getCorenovaID(context.baseUrl)
    .then (corenovaid) =>       
        return PutConfig(context.baseUrl,corenovaid,config)    
    .then (resp) =>
        #console.log resp
        return context
    .catch (err) =>
        throw err


#input to the validate is  { config:{}}
Validate =  (config) ->
    throw new Error "kaspersky.Validate - invalid input" unless config?
    chk = validate config ,schema_kaspersky
    console.log 'server validate result ', chk
    unless chk.valid
        throw new Error "server schema check failed"+  chk.valid
        return  false
    else
        return true

module.exports.start = Start
module.exports.stop = Stop
module.exports.update = Update
module.exports.validate = Validate