import React, { Component } from "react";
import { Provider } from "react-redux";
import "../calculator/style.css";

import Calculator from "../calculator/containers/Calculator";
import store from "../calculator/store";

class App extends Component {
  render() {
    return (
      <Provider store={store}>
        <Calculator />
      </Provider>
    );
  }
}

export default App
