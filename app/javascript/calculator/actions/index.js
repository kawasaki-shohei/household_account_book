import * as actionTypes from "../utils/actionTypes";
import calculateResult from "../utils/calculateResult";

export const toExpression = (type, payload) => ({
  type,
  payload
});

export const operationToExpression = op =>
  toExpression(actionTypes.ADD_OPERATION, op);

export const numberToExpression = num =>
  toExpression(actionTypes.ADD_NUMBER, num);

export const restoreExpression = payload => ({
  type: actionTypes.RESTORE_EXPRESSION,
  payload
});

export const addHistoryItem = expression => ({
  type: actionTypes.ADD_HISTORY_ITEM,
  payload: {
    expression,
    result: calculateResult(expression)
  }
});

export const backspaceExpression = () => ({
  type: actionTypes.BACKSPACE_EXPRESSION
});

export const allClear = () => ({
  type: actionTypes.ALL_CLEAR
});

export const addDecimalPoint = () => ({
  type: actionTypes.ADD_DECIMAL_POINT
});
