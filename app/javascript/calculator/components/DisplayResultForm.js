import React from "react";

const DisplayResultForm = ({ displayResult, currentExpression }) => {
  // 電卓の外の出費入力欄の値を変更する。
  if (currentExpression !== "") {
    const targetInputId = document.querySelector('#calculator-wrapper').getAttribute('data-calculator-for');
    const targetInput = document.querySelector(`#${targetInputId}`);
    targetInput.value = Number(displayResult);
  }

  return <input type="text" disabled="disabled" id="display-result" className="text-right" value={displayResult} ></input>;
};

export default DisplayResultForm;