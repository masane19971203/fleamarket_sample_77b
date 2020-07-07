$(function(){
  var htmlText = `<div class="htmlText">入力してください</div>`

  var htmlSelect = `<div class="htmlText">選択して下さい</div>`

  // 追加するカテゴリ選択肢のhtml
  function addoption(category) {
    var addselectoption = `<option value="${category.id}">${category.name}</option>`
    return addselectoption
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

  //商品一覧の最上部までスクロールさせる
  $(".product-list__categories__back-to-top").on("click",function(){
    $('body, html').animate({scrollTop: 0}, 300, 'linear');
  });

  //DataTransferオブジェクトで、データを格納する箱を作る
  var dataBox = new DataTransfer();
  var file_field = document.querySelector('input[type=file]')
  //fileが選択された時に発火するイベント
  $('.products-new__contents__form__image__select').change(function(){
    var files = $('input[type="file"]').prop('files')[0];
    $.each(this.files, function(i, file){
      //FileReaderのreadAsDataURLで指定したFileオブジェクトを読み込む
      var fileReader = new FileReader();
      var files = $('input[type="file"]').prop('files')[0];
      //DataTransferオブジェクトに対して、fileを追加
      dataBox.items.add(file)
      //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に代入
      file_field.files = dataBox.files
      var num = $('.item-image').length + 1 + i
      fileReader.readAsDataURL(file);
       //画像が10枚になったら超えたらドロップボックスを削除する
      if (num == 10){
        $('.products-new__contents__form__image__select').css('display', 'none')   
      }
      //読み込みが完了すると、srcにfileのURLを格納
      fileReader.onloadend = function() {
        var src = fileReader.result
        var html= `<div class='item-image' data-image="${file.name}">
                    <div class=' item-image__content'>
                      <div class='item-image__content--icon'>
                        <img src=${src} width="114" height="80" >
                      </div>
                    </div>
                    <div class='item-image__operetion'>
                      <div class='item-image__operetion--delete'>削除</div>
                    </div>
                  </div>`
        //image_box__container要素の前にhtmlを差し込む
        $('.products-new__contents__form__image--field__previews').append(html);
      };
    });    
  })


  // 追加した削除ボタンに対する挙動
  $(document).on("click", '.item-image__operetion--delete', function(){
    //削除を押されたプレビュー要素を取得
    var target_image = $(this).parent().parent()
    //削除を押されたプレビューimageのfile名を取得
    var target_name = $(target_image).data('image')
    //プレビューがひとつだけの場合、file_fieldをクリア
    if(file_field.files.length==1){
      //inputタグに入ったファイルを削除
      $('input[type=file]').val(null)
      dataBox.clearData();
    }else{
      //プレビューが複数の場合
      $.each(file_field.files, function(i,input){
        //削除を押された要素と一致した時、index番号に基づいてdataBoxに格納された要素を削除する
        if(input.name==target_name){
          dataBox.items.remove(i) 
        }
      })
      //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に再度代入
      file_field.files = dataBox.files
    }
    //プレビューを削除
    target_image.remove()
    //image-box__containerクラスをもつdivタグのクラスを削除のたびに変更
    var num = $('.item-image').length
    $('#image-box__container').show()
    $('#image-box__container').attr('class', `item-num-${num}`)
  })






  // 編集画面遷移時に、画像データ及びプレビューを反映させる
  $(window).on('load', function(){
    
    if($('#edit_item').length){
      var dropzone = $(".item__img__dropzone__input");
      var dropzone2 = $(".item__img__dropzone2__input2");
      var appendzone = $(".item__img__dropzone2")
      var input_area = $(".input-area");
      var preview = $("#preview");
      var preview2 = $("#preview2");

      // 登録済画像と新規追加画像を全て格納する配列（ビュー用）
      var images = [];
      // 登録済画像データだけの配列（DB用）
      var registered_images_ids =[]
      // 新規追加画像データだけの配列（DB用）
      var new_image_files = [];

      // 登録済画像のプレビュー表示
      gon.product_pictures.forEach(function(image, index){
        var img = $(`<div class= "add_img"><div class="img_area"><img class="image"  width="114" height="80"></div></div>`);
      
        // カスタムデータ属性を付与
        img.data("image", index)

        var btn_wrapper = $('<div class="btn_wrapper"><a class="btn_edit">編集</a><a class="btn_delete">削除</a></div>');

        // 画像に編集・削除ボタンをつける
        img.append(btn_wrapper);

        binary_data = gon.product_pictures_binary_datas[index]

        // 表示するビューにバイナリーデータを付与
        img.find("img").attr({
          src: "data:image/jpeg;base64," + binary_data
        });

        // 登録済画像のビューをimagesに格納
        images.push(img)
        registered_images_ids.push(image.id)
      })

      // 画像が４枚以下のとき
      if (images.length <= 4) {
        $('#preview').empty();
        $.each(images, function(index, image) {
          image.data('image', index);
          preview.append(image);
        })
        dropzone.css({
          'width': `calc(100% - (20% * ${images.length}))`
        })

        // 画像が５枚のとき１段目の枠を消し、２段目の枠を出す
      } else if (images.length == 5) {
        $("#preview").empty();
        $.each(images, function(index, image) {
          image.data("image", index);
          preview.append(image);
        });
        appendzone.css({
          display: "block"
        });
        dropzone.css({
          display: "none"
        });
        preview2.empty();

        // 画像が６枚以上のとき
      } else if (images.length >= 6) {
        // １〜５枚目の画像を抽出
        var pickup_images1 = images.slice(0, 5);

        // １〜５枚目を１段目に表示
        $('#preview').empty();
        $.each(pickup_images1, function(index, image) {
          image.data('image', index);
          preview.append(image);
        })

        // ６枚目以降の画像を抽出
        var pickup_images2 = images.slice(5);

        // ６枚目以降を２段目に表示
        $.each(pickup_images2, function(index, image) {
          image.data('image', index + 5);
          preview2.append(image);
        })

        dropzone.css({
          'display': 'none'
        })
        appendzone.css({
          'display': 'flex'
        })
        dropzone2.css({
          'display': 'block',
          'width': `calc(100% - (20% * ${images.length - 5}))`
        })

        // 画像が１０枚になったら枠を消す
        if (images.length == 10) {
          dropzone2.css({
            display: "none"
          });
        }
      }

      var new_image = $(
        `<input multiple= "multiple" name="item_images[image][]" class="upload-image" data-image= ${images.length} type="file" id="upload-image">`
      );
      input_area.append(new_image);
    }
    
    $("#edit_item .item__img__dropzone, #edit_item .item__img__dropzone2").on("change", 'input[type= "file"].upload-image', function() {
      var file = $(this).prop("files")[0];
      new_image_files.push(file)
      var reader = new FileReader();
      var img = $(`<div class= "add_img"><div class="img_area"><img class="image"  width="114" height="80"></div></div>`);
  
      reader.onload = function(e) {
        var btn_wrapper = $('<div class="btn_wrapper"><a class="btn_edit">編集</a><a class="btn_delete">削除</a></div>');
  
        // 画像に編集・削除ボタンをつける
        img.append(btn_wrapper);
        img.find("img").attr({
          src: e.target.result
        });
      };
  
      reader.readAsDataURL(file);
      images.push(img);
      
      // 画像が４枚以下のとき
      if (images.length <= 4) {
        $('#preview').empty();
        $.each(images, function(index, image) {
          image.data('image', index);
          preview.append(image);
        })
        dropzone.css({
          'width': `calc(100% - (20% * ${images.length}))`
        })

        // 画像が５枚のとき１段目の枠を消し、２段目の枠を出す
      } else if (images.length == 5) {
        $("#preview").empty();
        $.each(images, function(index, image) {
          image.data("image", index);
          preview.append(image);
        });
        appendzone.css({
          display: "flex"
        });
        dropzone.css({
          display: "none"
        });
        preview2.empty();

        // 画像が６枚以上のとき
      } else if (images.length >= 6) {

        // 配列から６枚目以降の画像を抽出
        var pickup_images = images.slice(5);

        $.each(pickup_images, function(index, image) {
          image.data("image", index + 5);
          preview2.append(image);
          dropzone2.css({
            width: `calc(100% - (20% * ${images.length - 5}))`
          });
        });

        // 画像が１０枚になったら枠を消す
        if (images.length == 10) {
          dropzone2.css({
            display: "none"
          });
        }
      }

      var new_image = $(
        `<input multiple= "multiple" name="item_images[image][]" class="upload-image" data-image= ${images.length} type="file" id="upload-image">`
      );
      input_area.append(new_image);

    });

    // 削除ボタン
    $("#edit_item .item__img__dropzone, #edit_item .item__img__dropzone2").on('click', '.btn_delete', function() {

      // 削除ボタンを押した画像を取得
      var target_image = $(this).parent().parent();

      // 削除画像のdata-image番号を取得
      var target_image_num = target_image.data('image');

      // 対象の画像をビュー上で削除
      target_image.remove();

      // 対象の画像を削除した新たな配列を生成
      images.splice(target_image_num, 1);

      // target_image_numが登録済画像の数以下の場合は登録済画像データの配列から削除、それより大きい場合は新たに追加した画像データの配列から削除
      if (target_image_num < registered_images_ids.length) {
        registered_images_ids.splice(target_image_num, 1);
      } else {
        new_image_files.splice((target_image_num - registered_images_ids.length), 1);
      }

      if(images.length == 0) {
        $('input[type= "file"].upload-image').attr({
          'data-image': 0
        })
      }

      // 削除後の配列の中身の数で条件分岐
      // 画像が４枚以下のとき
      if (images.length <= 4) {
        $('#preview').empty();
        $.each(images, function(index, image) {
          image.data('image', index);
          preview.append(image);
        })
        dropzone.css({
          'width': `calc(100% - (20% * ${images.length}))`,
          'display': 'block'
        })
        appendzone.css({
          'display': 'none'
        })

      // 画像が５枚のとき１段目の枠を消し、２段目の枠を出す
      } else if (images.length == 5) {
        $('#preview').empty();
        $.each(images, function(index, image) {
          image.data('image', index);
          preview.append(image);
        })
        appendzone.css({
          'display': 'block',
        })
        dropzone2.css({
          'width': '100%'
        })
        dropzone.css({
          'display': 'none'
        })
        preview2.empty();

      // 画像が６枚以上のとき
      } else {
        // １〜５枚目の画像を抽出
        var pickup_images1 = images.slice(0, 5);

        // １〜５枚目を１段目に表示
        $('#preview').empty();
        $.each(pickup_images1, function(index, image) {
          image.data('image', index);
          preview.append(image);
        })

        // ６枚目以降の画像を抽出
        var pickup_images2 = images.slice(5);

        // ６枚目以降を２段目に表示
        $.each(pickup_images2, function(index, image) {
          image.data('image', index + 5);
          preview2.append(image);
          dropzone2.css({
            'display': 'block',
            'width': `calc(100% - (20% * ${images.length - 5}))`
          })
        })
      }
    })

    $(".products-new__contents__form").on('submit', function(e){
      // 通常のsubmitイベントを止める
      e.preventDefault();
      // images以外のform情報をformDataに追加
      var formData = new FormData($(this).get(0));

      // 登録済画像が残っていない場合は便宜的に0を入れる
      if (registered_images_ids.length == 0) {
        formData.append("registered_images_ids[ids][]", 0)
      // 登録済画像で、まだ残っている画像があればidをformDataに追加していく
      } else {
        registered_images_ids.forEach(function(registered_image){
          formData.append("registered_images_ids[ids][]", registered_image)
        });
      }

      // 新しく追加したimagesがない場合は便宜的に空の文字列を入れる
      if (new_image_files.length == 0) {
        formData.append("new_images[pictures][]", " ")
      // 新しく追加したimagesがある場合はformDataに追加する
      } else {
        new_image_files.forEach(function(file){
          formData.append("new_images[pictures][]", file)
        });
      }

      $.ajax({
        url:         '/products/' + gon.product.id,
        type:        "PATCH",
        data:        formData,
        contentType: false,
        processData: false,
      })
      //商品編集の成否で各URLへ遷移
      .done(function(data){ 
        if(data.status == 0){
            var url = '/users/'+data.id+ '/products' 
        }
        else{ 
          var url = '/products/'+data.id+ '/edit'
        }
        window.location.href = url
      })
      .fail(function(){ 
      })
    });
  })
});