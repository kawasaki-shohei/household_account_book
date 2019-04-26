window.onload = function(){
  hiddenids = document.querySelector('#hidden-unread-ids-field').value;
  if (hiddenids !== ""){
    document.querySelector('#update-read-status-form').submit();
  }
};