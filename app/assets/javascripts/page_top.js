$(function() {
  //ページトップへのスクロール
  $('#page-top').click(function () {
    $("html,body").animate({scrollTop:0},"300");
  });
  //ページトップの出現
  $('#page-top').hide();
  $(window).scroll(function () {
    if($(window).scrollTop() > 0) {
      $('#page-top').slideDown(600);
    } else {
      $('#page-top').slideUp(600);
    }
  });
});