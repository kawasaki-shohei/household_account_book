import { combineReducers } from "redux";

import calculator from "./calculator";
import history from "./history";

export default combineReducers({
  calculator,
  history
});
