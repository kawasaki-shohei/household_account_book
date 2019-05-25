import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import * as actions from "../actions";
import History from "../components/History";

const mapStateToProps = state => ({
  list: state.history
});

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(actions, dispatch)
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(History);
