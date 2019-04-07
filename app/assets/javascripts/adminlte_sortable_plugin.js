// このファイルはjquery-uiのsortable.jsのためにAdminLTEがつけているpluginで、以下のファイルからsortableに必要なところだけを抜粋している。
// node_modules/admin-lte/dist/js/pages/dashboard.js

$(function () {

  'use strict';

  // jQuery UI sortable for the todo list
  $('.todo-list').sortable({
    placeholder         : 'sort-highlight',
    handle              : '.handle',
    forcePlaceholderSize: true,
    zIndex              : 999999
  });

});
