/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  config.PreserveSessionOnFileBrowser = true;
  config.language                     = 'en';
  config.height                       = '400px';
  config.width                        = '600px';
  config.extraPlugins                 = "embed,attachment";
  config.toolbar                      = 'Easy';
  
  config.toolbar_Easy =
    [
        ['Source','-','Preview','Templates'],
        ['Cut','Copy','Paste','PasteText','PasteFromWord',],
        ['Maximize','-','About'],
        ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
        ['Styles','Format'],
        ['Bold','Italic','Underline','Strike','-','Subscript','Superscript', 'TextColor'],
        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Link','Unlink','Anchor'],
        ['Image','Embed','Flash','Attachment','Table','HorizontalRule','Smiley','SpecialChar','PageBreak']
    ];

  config.filebrowserBrowseUrl       = '/ckeditor/attachments';
  config.filebrowserUploadUrl       = '/ckeditor/attachments';
  config.filebrowserImageBrowseUrl  = '/ckeditor/pictures';
  config.filebrowserImageUploadUrl  = '/ckeditor/pictures';
};

