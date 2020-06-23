$(function(){
  var html = `<div class="html">入力してください</div>`

  $(".contents__form__item__textarea").on('keyup', function() {
    var count = $(this).val().length;
    $('.contents__form__item__count').text(count + '/1000')
  });

  $(".insert").on('keyup blur', function() {
    if ($(this).val().length == 0 && !($(this).next('.html').length)) {
      $(this).css({'border-color': 'red'})
      $(this).after(html)
    } else if ($(this).val().length != 0 && ($(this).next('.html').length)) {
      $(this).css({'border-color': ''})
      $(this).next('.html').remove();
    }
  });
});