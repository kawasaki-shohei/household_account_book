import React from "react";

const OperationBtn = ({ display, onClick }) => {
  return <button className="button operation-btn" onClick={onClick}>{display}</button>;
};

export default OperationBtn;
