rewire = require 'rewire'
should = require('clay-chai').should()
query = require 'vtree-query'

HelloWorld = rewire './index'

describe 'z-hello-world', ->
  it 'goes to red page', (done) ->
    HelloWorld.__with__({
      'z.router.go': (path) ->
        path.should.be '/red'
        done()
    }) ->
      $hello = new HelloWorld()

      $hello.goToRed()

  it 'says Hello World', ->
    $hello = new HelloWorld()

    $ = query($hello.render())
    $('.content').contents.should.be 'Hello World'
