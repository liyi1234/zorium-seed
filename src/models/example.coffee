Rx = require 'rx-lite'

config = require '../config'
RequestService = require '../services/request'

PATH = config.API_URL

class Example
  get: ->
    Rx.Observable.fromPromise \
      RequestService PATH + '/api/demo'


module.exports = new Example()
