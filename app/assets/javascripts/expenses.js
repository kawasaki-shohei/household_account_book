$(function(){
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
})