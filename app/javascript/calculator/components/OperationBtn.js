import React from "react";

const OperationBtn = ({ display, onClick }) => {
  return <button onClick={onClick}>{display}</button>;
};

export default OperationBtn;
