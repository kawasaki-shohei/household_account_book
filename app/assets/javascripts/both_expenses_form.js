$(function(){
  $(document).on('click', 'input#percent_radio', function(){
    var chk_status = $('input#percent_radio').prop("checked");
    if (chk_status ){
      $('input#amount_radio').prop("checked", false);
      $('select#percent_input').removeAttr("disabled");
      $('input#mypay-input, input#partnerpay-input').attr("disabled", "disabled");
    } else {
      $('input#amount_radio').prop("checked", true);
      $('select#percent_input').attr("disabled", "disabled");
      $('input#mypay-input, input#partnerpay-input').removeAttr("disabled");
    }
  });

  $(document).on('click', 'input#amount_radio', function(){
    var chk_status = $('input#amount_radio').prop("checked");
    if (chk_status ){
      $('input#percent_radio').prop("checked", false);
      $('select#percent_input').attr("disabled", "disabled");
      $('input#mypay-input, input#partnerpay-input').removeAttr("disabled");
    } else {
      $('input#percent_radio').prop("checked", true);
      $('select#percent_input').removeAttr("disabled");
      $('input#mypay-input, input#partnerpay-input').attr("disabled", "disabled");
    }
  });

  $('input#mypay-input').change(function(){
    var paid_amount = $('input#both-expense-paid-amount').val();
    var mypay = $(this).val();
    var partnerpay = paid_amount - mypay
    if (partnerpay < 0){
      alert('支払金額を超えています。');
      $(this).val('');
      $('input#partnerpay-input').val('');
      $('input#mypay-input').focus();
    }else{
      $('input#partnerpay-input').val(partnerpay);
    }
  });

  $('input#partnerpay-input').change(function(){
    var paid_amount = $('input#both-expense-paid-amount').val();
    var partnerpay = $(this).val();
    var mypay = paid_amount - partnerpay;
    if (mypay < 0){
      alert('支払金額を超えています。');
      $(this).val('');
      $('input#mypay-input').val('');
      $('input#partnerpay-input').focus();
      return false;
    }else{
      $('input#mypay-input').val(mypay);
    }
  });

  $('input#both-expense-paid-amount').change(function(){
    $('input#mypay-input').val("");
    $('input#partnerpay-input').val("");
  });

});
