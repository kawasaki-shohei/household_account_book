import * as actionTypes from "../utils/actionTypes";

const DEFAULT_STATE = [];

export default (state = DEFAULT_STATE, action) => {
  switch (action.type) {
    case actionTypes.ADD_HISTORY_ITEM: {
      return [...state, action.payload];
    }
    default:
      return state;
  }
};
