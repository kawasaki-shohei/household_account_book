$(function(){
  $(document).on('click', 'input#percent_radio', function(){
    var chk_status = $('input#percent_radio').prop("checked");
    if (chk_status ){
      $('input#amount_radio').prop("checked", false);
      $('select#percent_input').removeAttr("disabled");
      $('input#mypay_input, input#partnerpay_input').attr("disabled", "disabled");
    } else {
      $('input#amount_radio').prop("checked", true);
      $('select#percent_input').attr("disabled", "disabled");
      $('input#mypay_input, input#partnerpay_input').removeAttr("disabled");
    }
  });

  $(document).on('click', 'input#amount_radio', function(){
    var chk_status = $('input#amount_radio').prop("checked");
    if (chk_status ){
      $('input#percent_radio').prop("checked", false);
      $('select#percent_input').attr("disabled", "disabled");
      $('input#mypay_input, input#partnerpay_input').removeAttr("disabled");
    } else {
      $('input#percent_radio').prop("checked", true);
      $('select#percent_input').removeAttr("disabled");
      $('input#mypay_input, input#partnerpay_input').attr("disabled", "disabled");
    }
  });

  $('input#mypay_input').change(function(){
    var paid_amount = $('input#paid_amount').val();
    var mypay = $(this).val();
    var partnerpay = paid_amount - mypay
    if (partnerpay < 0){
      alert('支払金額を超えています。');
      $(this).val('');
      $('input#partnerpay_input').val('');
      $('input#mypay_input').focus();
    }else{
      $('input#partnerpay_input').val(partnerpay);
    }
  });

  $('input#partnerpay_input').change(function(){
    var paid_amount = $('input#paid_amount').val();
    var partnerpay = $(this).val();
    var mypay = paid_amount - partnerpay;
    if (mypay < 0){
      alert('支払金額を超えています。');
      $(this).val('');
      $('input#mypay_input').val('');
      $('input#partnerpay_input').focus();
      return false;
    }else{
      $('input#mypay_input').val(mypay);
    }
  });

  $('input#paid_amount').change(function(){
    $('input#mypay_input').val("");
    $('input#partnerpay_input').val("");
  });
});


