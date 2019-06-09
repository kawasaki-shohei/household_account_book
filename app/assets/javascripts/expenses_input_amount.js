window.onload = function() {
  const calculatorBtns = document.querySelectorAll('.calculator-input-addon');
  calculatorBtns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
      const calculatorWrapper = document.querySelector('#calculator-wrapper');
      calculatorWrapper.setAttribute("data-calculator-for", e.currentTarget.getAttribute('data-calculator-for'));
    });
  });

  // todo: モーダルが非表示になったときも検知する。
  const closeBtn = document.querySelector('#close-calculator-btn');
  closeBtn.addEventListener('click', () => {
    const targetInputId = document.querySelector('#calculator-wrapper').getAttribute('data-calculator-for');
    if (targetInputId === "mypay-input" || targetInputId === "partnerpay-input") {
      // jsでinputの値を変更すると、changeイベントがせず差額の自動入力が実行されないため、changeイベントを発火させる。
      $(`#${targetInputId}`).change();
    }
  })
};