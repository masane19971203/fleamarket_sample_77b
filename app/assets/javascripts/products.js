$(function(){
  var htmlText = `<div class="htmlText">入力してください</div>`

  var htmlSelect = `<div class="htmlText">選択して下さい</div>`

  // 追加するカテゴリ選択肢のhtml
  function addoption(category) {
    var addselectoption = `<option value="${category.id}">${category.name}</option>`
    return addselectoption
  }

  // 追加する画像用フォームのhtml
  function addimagebox(){
    var imagebox = `
      <label class='image-form', id = 'image${$(".image-form").length + 1}'>
        <div class="products-new__contents__form__image__area">
          <i class="fa fa-camera products-new__contents__form__image__area__icon"></i>
          </i>
          <p class="products-new__contents__form__image__area__text">
            ドラッグアンドドロップ
            <br>
            またはクリックしてファイルをアップロード
          </p>
        </div>
        <input class="products-new__contents__form__image__select" type="file" name="product[ ][${$(".image-form").length}][image]" id="product_pictures_attributes_${$(".image-form").length}_image">
      </label>`

    return imagebox
  } 

  // 商品の説明のテキストに入力時、入力した文字数を表示
  $(".contents__form__item__textarea").on('keyup', function() {
    var count = $(this).val().length;
    $('.contents__form__item__count').text(count + '/1000')
  });

  // 入力必須なテキスト欄が未入力時に警告文を表示、入力時に警告文を削除
  $(".insert").on('keyup blur', function() {
    if ($(this).val().length == 0 && !($(this).next('.htmlText').length)) {
      $(this).css({'border-color': 'red'})
      $(this).after(htmlText)
    } else if ($(this).val().length != 0 && ($(this).next('.htmlText').length)) {
      $(this).css({'border-color': ''})
      $(this).next('.htmlText').remove();
    }
  });

  // セレクト欄で未選択でフォーカスが外れた時に、警告文を表示
  $(".category-select").on('blur', function() {
    if ($(this).val().length == 0 && !($(this).next('.htmlText').length)) {
      $(this).css({'border-color': 'red'})
      $(this).after(htmlSelect);
    }
  });

  // セレクト欄で選択に、警告文を削除
  $(".category-select").on("change",function() {
    if ( $(this).val() != "" ) {
      $(this).next('.htmlText').remove()
      $(this).css({'border-color': ''})
    } 
  });

  // カテゴリー欄で選択・未選択時に、サブカテゴリー1以下の表示・削除
  $(".products-select").on("change",function() {
    // ↓controller反映時にifの条件の変更をお願いします
    if ( $(this).val() != "" ) {
      $(".hidden1").css({"display": "block"})

      // 選択された親カテゴリーの子カテゴリーのみを表示させる
      var val = $(this).val();
      $.ajax({
        url:  '/exhibition',
        type: "GET",
        data:{ category_id: val}
      })
      .done(function(data){
        $('.hidden1').empty();
        $.each(data.category, function(index, value){
          $('.hidden1').append(addoption(data.category[index]));
        })

      })
    }else {
      
      $(".hidden1,.hidden2,.hidden-size,.hidden3").css({"display": "none", 'border-color': ''})
      $(".hidden1,.hidden2,.hidden3").next('.htmlText').remove()
      $(".hidden1,.hidden2,.hidden3").val("");
    }
  });
  
  // サブカテゴリー1欄で選択・未選択時に、サブカテゴリー2以下の表示・削除
  $(".hidden1").on("change",function() {
    // ↓controller反映時にifの条件の変更をお願いします
    if ( $(this).val() != "" ) {
      $(".hidden2").css({"display": "block"})

      // 選択された子カテゴリーの孫カテゴリーのみを表示させる
      var val = $(this).val();
      $.ajax({
        url:  '/exhibition',
        type: "GET",
        data:{ category_id: val}
      })
      .done(function(data){
        $('.hidden2').empty();
        $.each(data.category, function(index, value){
          $('.hidden2').append(addoption(data.category[index]));
        })

      })
      
    } 
    else {
      $(".hidden2,.hidden-size,.hidden3").css({"display": "none", 'border-color': ''})
      $(".hidden2,.hidden3").next('.htmlText').remove()
      $(".hidden2,.hidden3").val('');
    }
  });

  // サブカテゴリー2欄で選択・未選択時に、サイズ選択肢の表示・削除
  $(".hidden2").on("change",function() {
    // ↓controller反映時にifの条件の変更をお願いします
    if ( $(this).val() != "" ) {
      $(".hidden3").css({"display": "block"})
      $(".hidden-size").css({"display": "flex"})
    } 
    else {
      $(".hidden-size,.hidden3").css({"display": "none", 'border-color': ''})
      $(".hidden3").next('.htmlText').remove()
      $(".hidden3").val('');
    }
  });

  // 画像が選択された際のプレビュー処理
  $(".products-new__contents__form__image--field").on('change', function(){  
    var selecter = "product_pictures_attributes_"+($(".image-form").length-1)+"_image"
    console.log(selecter);

    var file = $('#'+selecter).prop('files')[0];
    var fileReader = new FileReader();


    //読み込みが完了すると、srcにfileのURLを格納
    fileReader.onloadend = function() {
      var src = fileReader.result
      var html= `
        <div class='item-image' data-image="${file.name}">
          <div class=' item-image__content'>
            <div class='item-image__content--icon'>
              <img src=${src} width="114" height="80" >
            </div>
          </div>
        </div>`
      //image_box__container要素の前にhtmlを差し込む
      $('.products-new__contents__form__image--field__previews').append(html);
    }
    fileReader.readAsDataURL(file);

    $('#'+ selecter).parent().addClass('hidden');

    // 新しい画像フォームを表示
    $(".products-new__contents__form__image--field").append(addimagebox())

  })

});