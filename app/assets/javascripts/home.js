$(function () {
  var pagetop = $('#page_top');
  pagetop.hide();
  $(window).scroll(function () {
    if ($(this).scrollTop() > 100) {  //100pxスクロールしたら表示
      pagetop.fadeIn();
    } else {
      pagetop.fadeOut();
    }
  });

  $('a[href^="#"]').click(function () {
    var href = $(this).attr("href");
    var target = $(href == "#" || href == "" ? 'html' : href);
    var position = target.offset().top;
    $("html, body").animate({
      scrollTop: position
    }, 500, "swing");
    return false;
  });
  $('.menu-btn').on('click', function () {
    $('.menu').toggleClass('is-active');
  });
});
