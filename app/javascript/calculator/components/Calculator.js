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
    <div id="calculator-body">
      <div id="calculator-content">
        <div id="display-body">
          <input disabled="disabled" id="current-expression" value={currentExpression} ></input>
          <input disabled="disabled" id="display-result" className="text-right" value={displayResult} ></input>
        </div>

        <div id="calculator-btn-section">
          <table id="calculator-btn-table">
            <tbody>
            <tr>
              <td className="caluclator-btn">
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
              <td className="text-right">
                <OperationBtn
                  display={"÷"}
                  onClick={() => actions.operationToExpression("÷")}
                />
              </td>
            </tr>
            <tr className="calculator-number-section">
              <td>
                <NumberBtn n={7} onClick={() => actions.numberToExpression(7)} />
              </td>
              <td>
                <NumberBtn n={8} onClick={() => actions.numberToExpression(8)} />
              </td>
              <td>
                <NumberBtn n={9} onClick={() => actions.numberToExpression(9)} />
              </td>
              <td className="text-right">
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
              <td className="text-right">
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
              <td className="text-right">
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
              <td className="text-right">
                <NeutralBtn
                  onClick={() => actions.showSolution(currentExpression)}
                />
              </td>
            </tr>
            </tbody>
          </table>
        </div>{/*calculator-btn-section*/}


      </div>
    </div>
  );
};

export default Calculator;
