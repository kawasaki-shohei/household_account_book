window.onload = function() {
  const calculatorBtns = document.querySelectorAll('.calculator-input-addon');
  calculatorBtns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
      const calculatorWrapper = document.querySelector('#calculator-wrapper');
      calculatorWrapper.setAttribute("data-calculator-for", e.currentTarget.getAttribute('data-calculator-for'));
    });
  });
};