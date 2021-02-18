( function _EncodersExtended_test_ss_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );
  require( '../l4_files/entry/EncodersExtended.s' );
  _.include( 'wTesting' );
}

//

let _ = _global_.wTools;
let Parent = wTester;

//

function onSuiteBegin()
{
  let context = this;
  context.provider = _.FileProvider.HardDrive();
  context.suiteTempPath = context.provider.path.tempOpen( 'EncodersExtended' );
}

//

function onSuiteEnd()
{
  let context = this;
  // _.assert( _.strHas( this.suiteTempPath, 'tmp.tmp' ) );
  context.provider.path.tempClose( this.suiteTempPath );
  this.provider.finit();
}

//

function pathFor( filePath )
{
  let path = this.provider.path;
  filePath = path.join( this.suiteTempPath, filePath );
  return path.normalize( filePath );
}

// --
// tests
// --

function readWriteCson( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = context.pathFor( 'written/' + test.name );
  let testFilePath = path.join( testPath, 'config.cson' );

  /**/

  let src =
  {
    string : 'string',
    number : 1.123,
    bool : false,
    array : [ 1, '1', true ],
    regexp : /\.string$/,
    map : { a : 'string', b : 1, c : false },
  }

  let src2 = { a0 : { b0 : { c0 : { p : 1 }, c1 : 1 }, b1 : 1 }, a1 : 1 };

  /**/

  test.case = 'write and read cson file, using map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src, encoding : 'cson' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'cson' });
  test.identical( got, src );
  var got = provider.fileRead({ filePath : testFilePath });
  var expected =
`string: 'string'
number: 1.123
bool: false
array: [
  1
  '1'
  true
]
regexp: /\\.string$/
map:
  a: 'string'
  b: 1
  c: false
`
  test.identical( got, expected )

  /**/

  test.case = 'write and read cson file, using complex map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src2, encoding : 'cson' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'cson' });
  test.identical( got, src2 );
  var got = provider.fileRead({ filePath : testFilePath });
  console.log( got )
  var expected =
`a0:
  b0:
    c0: p: 1
    c1: 1
  b1: 1
a1: 1
`
  test.identical( got, expected )
}

//

function readWriteYaml( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = context.pathFor( 'written/' + test.name );
  let testFilePath = path.join( testPath, 'config.yml' );

  /**/

  let src =
  {
    string : 'string',
    number : 1.123,
    bool : false,
    array : [ 1, '1', true ],
    regexp : /\.string$/,
    map : { a : 'string', b : 1, c : false },
  }

  let src2 = { a0 : { b0 : { c0 : { p : 1 }, c1 : 1 }, b1 : 1 }, a1 : 1 };

  /* */

  test.case = 'write and read yaml file, using map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src, encoding : 'yaml' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'yaml' });
  test.identical( got, src );
  var got = provider.fileRead({ filePath : testFilePath });
  var expected =
`string: string
number: 1.123
bool: false
array:
  - 1
  - '1'
  - true
regexp: !<tag:yaml.org,2002:js/regexp> /\\.string$/
map:
  a: string
  b: 1
  c: false
`
  test.identical( got, expected )

  /**/

  test.case = 'write and read yaml file, using complex map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src2, encoding : 'yaml' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'yaml' });
  test.identical( got, src2 );
  var got = provider.fileRead({ filePath : testFilePath });
  var expected =
`a0:
  b0:
    c0:
      p: 1
    c1: 1
  b1: 1
a1: 1
`
  test.identical( got, expected )

}

//

function readWriteBson( test )
{
  let context = this;
  let provider = context.provider;
  let path = provider.path;
  let testPath = context.pathFor( 'written/' + test.name );
  let testFilePath = path.join( testPath, 'config' );

  let src =
  {
    string : 'string',
    number : 1.123,
    bool : false,
    array : [ 1, '1', true ],
    regexp : /\.string$/,
    map : { a : 'string', b : 1, c : false },
  }

  /**/

  test.case = 'write and read yaml file, using map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src, encoding : 'bson' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'bson' });
  test.identical( got, src );
}

// --
// declare
// --

let Self =
{

  name : 'Tools/mid/files/EncodersExtended',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    pathFor,
    provider : null,
  },

  tests :
  {
    readWriteCson,
    readWriteYaml,
    readWriteBson,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
