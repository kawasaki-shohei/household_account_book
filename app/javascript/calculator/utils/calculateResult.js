import Decimal from "decimal.js";

const replace_expression = expression => {
  return expression
    .replace(/=\s*$/, "")
    .replace("×", "*")
    .replace("÷", "/");
};

const counter = (str, seq) => {
  return str.split(seq).length - 1;
};

const isCorrectNumberOfBranckets = expression => {
  const numberOfOpenBrancket = counter(expression, "(");
  const numberOfCloseBrancket = counter(expression, ")");
  return numberOfOpenBrancket === numberOfCloseBrancket;
};

export default expression => {
  const lastLetter = expression.slice(-1);
  const isLastLetterArithmeticOperator = /[÷×+-]/.test(lastLetter);
  const isLastLetterOpenBrancket = /\(/.test(lastLetter);

  let finalExpression = expression;
  // "("なら計算できないからreturnする
  if (isLastLetterOpenBrancket || expression === "") {
    return "";
  }

  if (isLastLetterArithmeticOperator) {
    finalExpression = expression.slice(0, -1);
  }
  console.log(`finalExpression: ${finalExpression}`); // これ残す
  if (isCorrectNumberOfBranckets(expression)) {
    const ans = eval(replace_expression(finalExpression));
    // Decimalは少数点の計算ではなく、整数のときや少数点以下の0を表示しないようにするために使っている。
    return new Decimal(ans.toFixed(3)).toNumber();
  } else {
    return "";
  }
};
