import React from "react";

const DisplayResultForm = ({ displayResult, currentExpression }) => {
  if (currentExpression !== "") {
    const targetInputId = document.querySelector('#calculator-wrapper').getAttribute('data-calculator-for');
    const targetInput = document.querySelector(`#${targetInputId}`);
    targetInput.value = Number(displayResult);
    // jsでinputの値を変更すると、changeイベントが発火しないため、発火させる
    if (targetInputId === "mypay-input" || targetInputId === "partnerpay-input") {
      $(`#${targetInputId}`).change();
    }
  }

  return <input type="text" disabled="disabled" id="display-result" className="text-right" value={displayResult} ></input>;
};

export default DisplayResultForm;