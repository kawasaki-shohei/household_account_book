import * as actionTypes from "../utils/actionTypes";
import calculateResult from "../utils/calculateResult";

const hasNeutral = expression => {
  return expression.includes("=");
};

const checkAndReplaceDicimalPoint = expression => {
  if (hasNeutral(expression)) {
    return "0.";
  } else {
    const lastLetter = expression.slice(-1);
    if (/[.]/.test(lastLetter)) {
      return expression;
    } else if (!/[\d]/.test(lastLetter)) {
      return expression + "0.";
    } else {
      return expression + ".";
    }
  }
};

const addOperationToExpression = (expression, addtionalLetter) => {
  const lastLetter = expression.slice(-1);
  // const isLastLetterNumber = /[\d]/.test(lastLetter);
  // const isAdditionalLetterBracket = /[()]/.test(addtionalLetter);
  const isLastLetterArithmeticOperator = /[÷×+-]/.test(lastLetter); // ArithmeticOperator: 四則演算子
  const isAddtionalLetterArithmeticOperator = /[÷×+-]/.test(addtionalLetter);
  if (hasNeutral(expression)) {
    if (isAddtionalLetterArithmeticOperator) {
      return getCurrentNumber(expression).toString() + addtionalLetter;
    } else {
      return getCurrentNumber(expression).toString();
    }
  } else if (
    isLastLetterArithmeticOperator &&
    isAddtionalLetterArithmeticOperator
  ) {
    return expression.slice(0, -1) + addtionalLetter;
  } else {
    return expression + addtionalLetter;
  }
};

// @return [String]
const getDecimalDisplay = (expression, currentNumber) => {
  const lastLetter = expression.slice(-1);
  if (/[.]/.test(lastLetter)) {
    return currentNumber + ".";
  } else if (!/[\d]/.test(lastLetter)) {
    return "0.";
  } else {
    return currentNumber + ".";
  }
};

const getCurrentNumber = expression => {
  const isLastLetterNumber = /[\d.]/.test(expression.slice(-1));
  if (!isLastLetterNumber) {
    return "";
  }
  const revercedExpression = expression.split("").reverse();
  let currentNumberArray = [];
  for (let str of revercedExpression) {
    if (!/[\d.]/.test(str)) {
      break;
    }
    currentNumberArray.unshift(str);
  }
  return Number(currentNumberArray.join(""));
};

const backspaceExpression = expression => {
  if (hasNeutral(expression)) {
    return expression.slice(0, expression.lastIndexOf("="));
  } else {
    return expression.slice(0, -1);
  }
};

const INITIAL_STATE = {
  currentExpression: "",
  currentNumber: 0,
  currentResult: 0,
  displayResult: 0
};

export default (state = INITIAL_STATE, action) => {
  let expression = "";
  let currentNumber = 0;
  let currentResult = 0;

  switch (action.type) {
    case actionTypes.ADD_NUMBER:
      if (hasNeutral(state.currentExpression)) {
        expression = String(action.payload);
      } else {
        expression = state.currentExpression + action.payload;
      }
      currentNumber = getCurrentNumber(expression);
      return {
        ...state,
        currentExpression: expression,
        currentNumber: currentNumber,
        displayResult: currentNumber
      };

    case actionTypes.ADD_DECIMAL_POINT:
      expression = checkAndReplaceDicimalPoint(state.currentExpression);
      return {
        ...state,
        currentExpression: expression,
        displayResult: getDecimalDisplay(
          state.currentExpression,
          state.currentNumber
        )
      };

    case actionTypes.ADD_OPERATION:
      console.log(state.currentNumber);
      expression = addOperationToExpression(
        state.currentExpression,
        action.payload
      );
      currentResult = calculateResult(expression);
      return {
        ...state,
        currentExpression: expression,
        currentNumber: 0,
        currentResult: currentResult,
        displayResult: currentResult
      };

    case actionTypes.ADD_HISTORY_ITEM:
      currentResult = calculateResult(state.currentExpression).toString();
      return {
        ...state,
        currentExpression: state.currentExpression + "=" + currentResult,
        currentNumber: currentResult,
        currentResult: currentResult,
        displayResult: currentResult
      };

    case actionTypes.BACKSPACE_EXPRESSION:
      expression = backspaceExpression(state.currentExpression);
      return {
        ...state,
        currentExpression: expression,
        currentResult: calculateResult(expression),
        currentNumber: getCurrentNumber(expression),
        displayResult: calculateResult(expression)
      };

    case actionTypes.ALL_CLEAR:
      return INITIAL_STATE;

    case actionTypes.RESTORE_EXPRESSION:
      expression = action.payload;
      currentResult = calculateResult(expression);
      return INITIAL_STATE;

    default:
      return state;
  }
};
