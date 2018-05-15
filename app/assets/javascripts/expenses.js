$(function(){
  $('input:visible').eq(0).focus();

  $(document).on('click', 'input#percent_checkbox', function(){
    var chk_status = $('input#percent_checkbox').prop("checked");
    if (chk_status ){
      $('input#amount_checkbox').prop("checked", false);
      $('select#percent_input').removeAttr("disabled");
      $('input#maypay_input, input#partnerpay_input').attr("disabled", "disabled");
    } else {
      $('input#amount_checkbox').prop("checked", true);
      $('select#percent_input').attr("disabled", "disabled");
      $('input#maypay_input, input#partnerpay_input').removeAttr("disabled");
    }
  });

  $(document).on('click', 'input#amount_checkbox', function(){
    var chk_status = $('input#amount_checkbox').prop("checked");
    if (chk_status ){
      $('input#percent_checkbox').prop("checked", false);
      $('select#percent_input').attr("disabled", "disabled");
      $('input#maypay_input, input#partnerpay_input').removeAttr("disabled");
    } else {
      $('input#percent_checkbox').prop("checked", true);
      $('select#percent_input').removeAttr("disabled");
      $('input#maypay_input, input#partnerpay_input').attr("disabled", "disabled");
    }
  });

  $('input#maypay_input').change(function(){
    var paid_amount = $('input#paid_amount').val();
    var mypay = $(this).val();
    var partnerpay = paid_amount - mypay
    if (partnerpay < 0){
      alert('支払金額を超えています。');
      $('input#maypay_input').focus();
    }else{
      $('input#partnerpay_input').val(partnerpay);
    }
  });

  $('input#partnerpay_input').change(function(){
    var paid_amount = $('input#paid_amount').val();
    var partnerpay = $(this).val();
    var mypay = paid_amount - partnerpay
    if (mypay < 0){
      alert('支払金額を超えています。');
      $('input#partnerpay_input').focus();
      return false;
    }else{
      $('input#maypay_input').val(mypay);
    }
  });

  $('input#paid_amount').change(function(){
    $('input#maypay_input').val("");
    $('input#partnerpay_input').val("");
  });

  // $('form#both_form').on('submit', function(){
  //   var chk_status = $('input#amount_checkbox').prop("checked");
  //   var mypay = $('input#maypay_input').val();
  //   var partnerpay = $('input#partnerpay_input').val();
  //   var paid_amount = $('input#paid_amount').val();
  //   var chk_amount = mypay + partnerpay
  //   if (chk_status && chk_amount != paid_amount){
  //     alert('支払金額と一致しません');
  //     $('input#maypay_input').focus();
  //     return false;
  //   }
  // });
})
