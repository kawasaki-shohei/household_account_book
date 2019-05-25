import React from "react";

const NumBtn = ({ n, onClick }) => {
  return <button onClick={onClick}>{n}</button>;
};

export default NumBtn;
