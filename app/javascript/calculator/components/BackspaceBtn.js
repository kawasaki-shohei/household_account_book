import React from "react";

const BackspaceBtn = ({ onClick }) => {
  return <button className="button" onClick={onClick}><i className="fa fa-arrow-left"></i></button>;
};

export default BackspaceBtn;
