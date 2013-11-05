###
./node_modules/.bin/mocha --compilers coffee:coffee-script --require coffee-script HttpBenchmarkSpec.coffee
###
sinon = require 'sinon'
should = require('chai').should()
HttpBenchmark = require('./HttpBenchmark.coffee').HttpBenchmark

describe 'HttpBenchmark', ->

  beforeEach ->
    @concurrentThreads = 10
    @requestsPerThread = 20
    @httpBenchmark = new HttpBenchmark
      concurrentThreads: @concurrentThreads
      requestsPerThread: @requestsPerThread

  it 'should create the correct number of threads', (done) ->
    spy = sinon.spy()
    @httpBenchmark.createThread = spy
    @httpBenchmark.sendRequest = sinon.stub()
    @httpBenchmark.start()
    spy.callCount.should.equal @concurrentThreads
    done()

  it 'should create the correct number of requests per threads', (done) ->
    stub = sinon.stub()
    @httpBenchmark.sendRequest = (callback) ->
      stub()
      callback()
    @httpBenchmark.options.concurrentThreads = 1
    @httpBenchmark.start()
    stub.callCount.should.equal @requestsPerThread
    done()

  it 'should create the correct total requests', (done) ->
    stub = sinon.stub()
    @httpBenchmark.sendRequest = (callback) ->
      stub()
      callback()
    @httpBenchmark.start()
    stub.callCount.should.equal @concurrentThreads * @requestsPerThread
    done()