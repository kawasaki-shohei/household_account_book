import React from "react";

const History = ({ list = [], actions }) => {
  return (
    <fieldset>
      <legend>History:</legend>
      <ul>
        {list.map((item, index) => (
          <li
            key={index}
            onClick={() => actions.restoreExpression(item.expression)}
          >
            {item.expression} = {item.result}
          </li>
        ))}
      </ul>
    </fieldset>
  );
};

export default History;
