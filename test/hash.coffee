{should, expect}  = require 'chai'
{Hash}  = require '../src/strictly-hash'
should()
describe 'Hash Class Test Suite', ->
  it 'should get values from an object', =>
    (new Hash value:'test').get('value').should.equal 'test'
  it 'should set values to the Hash', =>
    (new Hash).set('value', 'test').get('value').should.equal 'test'
  it 'should set list keys in the Hash', =>
    (hash = new Hash).set('value', 'test')
    hash.keys()[0].should.equal 'value'
  it 'should delete an item in the Hash', =>
    (hash = new Hash value:'test', invalid:true).del('invalid')
    expect(hash.get 'invalid').to.equal undefined
  it 'should restrict values based on array', =>
    expect((new Hash {},['value']).set('illegal', true).get('illegal')).to.equal undefined
  it 'should restrict values based on type', =>
    expect((new Hash {value:1},[], {value:"typeof:string"}).get('value')).to.equal undefined
    expect((new Hash {value:1},[], {value:"typeof:object"}).get('value')).to.equal undefined
    expect((new Hash {value:1},[], {value:"typeof:number"}).get('value')).to.equal 1
  it 'should cast values to a type', =>
    expect((new Hash {value:1},[], {value:"cast:String"}).get('value')).to.equal '1'
  it 'should create class from values', =>
    _h = new Hash {value:{foo:'bar'}}, [], {value:'class:Hash'}
    expect(_h.get('value').get 'foo').to.equal 'bar'
  it 'should freeze', =>
    (hash = new Hash value:'you can\'t touch this').freeze().isFrozen().should.equal  true
    expect((=>hash.set 'value','it\'s Hammer Time!')).to.throw "Cannot assign to read only property 'value' of object '#<Object>'"
    hash.get('value').should.equal 'you can\'t touch this'
  it 'should seal', =>
    (hash = new Hash value:'you can\'t touch this').seal().isSealed().should.equal  true
    expect((=> hash.set 'something',(->false))).to.throw "Can't add property something, object is not extensible"
  it 'should prevent extension', =>
    (hash = new Hash value:'you can\'t touch this').preventExtensions().isExtensible().should.equal  false
    expect((=> hash.set 'something',(->false))).to.throw "Can't add property something, object is not extensible"
  it "should provide it's value", =>
    (new Hash {value:'test'},['value']).valueOf().value.should.equal 'test'
  it "should provide toJSON", =>
    (new Hash {value:'test'},['value']).toJSON().value.should.equal 'test'
  it "should provide toString", =>
    (new Hash {value:'test'},['value']).toString().should.be.a 'string'
  it 'should keep hashes discrete', =>
    one = new Hash {value:"foo"}
    two = new Hash {value:"bar"}
    one.get('value').should.equal 'foo'
    two.get('value').should.equal 'bar'
