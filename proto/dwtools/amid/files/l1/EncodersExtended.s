(function _EncodersExtended_s_() {

'use strict';

/**
 * Collection of files transformers for Files module. Use it to read configs in different formats.
  @module Tools/mid/files/FilesTransformers
*/

/**
 * @file files/EncodersExtended.s.
 */

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );
  _.include( 'wFiles' );

}

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

// let ReadEncoders = _.FileProvider.Partial.prototype.fileRead.encoders;
// let WriteEncoders = _.FileProvider.Partial.prototype.fileWrite.encoders;

// --
//
// --

let Coffee;
try
{
  Coffee = require( 'coffee-script' );
}
catch( err )
{
}

let readCoffee = null;
if( Coffee )
readCoffee =
{

  exts : [ 'coffee' ],
  forConfig : 1,

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'coffee' || e.operation.encoding === 'cson' );
    e.operation.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    _.assert( _.strIs( e.data ), '( fileRead.ReadEncoders.coffee.onEnd ) expects string' );
    e.data = Coffee.eval( e.data, { filename : e.operation.filePath } );
  },

}

let Js2coffee;
try
{
  Js2coffee = require( 'js2coffee' );
}
catch( err )
{
}

let writeCoffee = null;
if( Js2coffee )
writeCoffee =
{

  exts : [ 'coffee' ],

  onBegin : function( e )
  {
    debugger;
    _.assert( e.operation.encoding === 'coffee' || e.operation.encoding === 'cson' );
    try
    {
      let data = _.toStr( e.operation.data, { jsLike : 1, keyWrapper : '' } );
      if( _.mapIs( e.operation.data ) )
      data = '(' + data + ')';
      e.operation.data = Js2coffee( data );
    }
    catch( err )
    {
      debugger;
      throw _.err( err );
    }
    e.operation.encoding = 'utf8';
    debugger;
  },

}

//

let Yaml;
try
{
  Yaml = require( 'js-yaml' );
}
catch( err )
{
}

let readYml = null;
if( Yaml )
readYml =
{

  exts : [ 'yaml','yml' ],
  forConfig : 1,

  onBegin : function( e )
  {
    _.assert( _.arrayHas( [ 'yaml', 'yml' ], e.operation.encoding ) );
    e.operation.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    _.assert( _.strIs( e.data ), '( fileRead.ReadEncoders.coffee.onEnd ) expects string' );
    try
    {
      e.data = Yaml.load( e.data,{ filename : e.operation.filePath } );
    }
    catch( err )
    {
      debugger;
      throw _.err( err );
    }
  },

}

let writeYml = null;
if( Yaml )
writeYml =
{

  exts : [ 'yaml','yml' ],

  onBegin : function( e )
  {
    _.assert( _.arrayHas( [ 'yaml', 'yml' ], e.operation.encoding ) );
    try
    {
      e.operation.data = Yaml.dump( e.operation.data );
    }
    catch( err )
    {
      debugger;
      throw _.err( err );
    }
    e.operation.encoding = 'utf8';
  },

}

//

let Bson;
try
{
  Bson = require( 'bson' );
}
catch( err )
{
}

let readBson = null;
if( Bson )
readBson =
{

  forConfig : 1,

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'bson' );
    e.operation.encoding = 'buffer.node';
  },

  onEnd : function( e )
  {
    _.assert( _.bufferNodeIs( e.data ), '( fileRead.ReadEncoders.Bson.onEnd ) expects node buffer' );
    try
    {
      e.data = Bson.deserialize( e.data );
    }
    catch( err )
    {
      debugger;
      throw _.err( err );
    }
  },

}

let writeBson = null;
if( Bson )
writeBson =
{
  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'bson' );
    try
    {
      e.operation.data = Bson.serialize( e.operation.data );
    }
    catch( err )
    {
      debugger;
      throw _.err( err );
    }
    e.operation.encoding = 'buffer.node';
  },

}

// --
// declare
// --

let FileReadEncoders =
{

  'yaml' : readYml,
  'yml' : readYml,
  'coffee' : readCoffee,
  'cson' : readCoffee,
  'bson' : readBson,

}

let FileWriteEncoders =
{

  'yaml' : writeYml,
  'yml' : writeYml,
  'coffee' : writeCoffee,
  'cson' : writeCoffee,
  'bson' : writeBson,

}

_.FileReadEncoders = _.FileReadEncoders || Object.create( null );
_.FileWriteEncoders = _.FileWriteEncoders || Object.create( null );

Object.assign( _.FileReadEncoders, FileReadEncoders );
Object.assign( _.FileWriteEncoders, FileWriteEncoders );

if( _.FileProvider && _.FileProvider.Partial && _.FileProvider.Partial.prototype.fileRead.encoders )
_.assert( _.prototypeOf( _.FileReadEncoders, _.FileProvider.Partial.prototype.fileRead.encoders ) );
if( _.FileProvider && _.FileProvider.Partial && _.FileProvider.Partial.prototype.fileWrite.encoders )
_.assert( _.prototypeOf( _.FileWriteEncoders, _.FileProvider.Partial.prototype.fileWrite.encoders ) );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
