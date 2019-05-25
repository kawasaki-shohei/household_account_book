import React from "react";
import NumberBtn from "./NumberBtn";
import OperationBtn from "./OperationBtn";
import BackspaceBtn from "./BackspaceBtn";
import AllClearBtn from "./AllClearBtn";
import NeutralBtn from "./NeutralBtn";
import DecimalPointBtn from "./DecimalPointBtn";

const Calculator = ({ calculator, actions }) => {
  const { currentExpression, displayResult } = calculator;
  return (
    <fieldset>
      <legend>Calculator</legend>
      <div>
        <input disabled="disabled" value={currentExpression} />
      </div>
      <div>
        <input
          type="text"
          disabled="disabled"
          value={displayResult}
          id="display-field"
        />
      </div>

      <table>
        <tbody>
          <tr>
            <td>
              <AllClearBtn onClick={() => actions.allClear()} />
            </td>
            <td>
              <OperationBtn
                display={"("}
                onClick={() => actions.operationToExpression("(")}
              />
            </td>
            <td>
              <OperationBtn
                display={")"}
                onClick={() => actions.operationToExpression(")")}
              />
            </td>
            <td>
              <OperationBtn
                display={"÷"}
                onClick={() => actions.operationToExpression("÷")}
              />
            </td>
          </tr>
          <tr>
            <td>
              <NumberBtn n={7} onClick={() => actions.numberToExpression(7)} />
            </td>
            <td>
              <NumberBtn n={8} onClick={() => actions.numberToExpression(8)} />
            </td>
            <td>
              <NumberBtn n={9} onClick={() => actions.numberToExpression(9)} />
            </td>
            <td>
              <OperationBtn
                display={"×"}
                onClick={() => actions.operationToExpression("×")}
              />
            </td>
          </tr>
          <tr>
            <td>
              <NumberBtn n={4} onClick={() => actions.numberToExpression(4)} />
            </td>
            <td>
              <NumberBtn n={5} onClick={() => actions.numberToExpression(5)} />
            </td>
            <td>
              <NumberBtn n={6} onClick={() => actions.numberToExpression(6)} />
            </td>
            <td>
              <OperationBtn
                display={"-"}
                onClick={() => actions.operationToExpression("-")}
              />
            </td>
          </tr>
          <tr>
            <td>
              <NumberBtn n={1} onClick={() => actions.numberToExpression(1)} />
            </td>
            <td>
              <NumberBtn n={2} onClick={() => actions.numberToExpression(2)} />
            </td>
            <td>
              <NumberBtn n={3} onClick={() => actions.numberToExpression(3)} />
            </td>
            <td>
              <OperationBtn
                display={"+"}
                onClick={() => actions.operationToExpression("+")}
              />
            </td>
          </tr>
          <tr>
            <td>
              <BackspaceBtn onClick={actions.backspaceExpression} />
            </td>
            <td>
              <NumberBtn n={0} onClick={() => actions.numberToExpression(0)} />
            </td>
            <td>
              <DecimalPointBtn onClick={() => actions.addDecimalPoint()} />
            </td>
            <td>
              <NeutralBtn
                onClick={() => actions.addHistoryItem(currentExpression)}
              />
            </td>
          </tr>
        </tbody>
      </table>
      <br />
    </fieldset>
  );
};

export default Calculator;
