// 今のactiveになっているタブを取得
const getCurrentTabStr = () => {
  return `${document.querySelector('ul.nav-tabs>li.active').id.replace('-tab', '')}`
};

const yearMonthSelect = document.querySelector('#year-month-select');
// 月を選択するセレクトボックスを変更したときに検索ボタンのパスを変更する
yearMonthSelect.addEventListener('change', (e) => {
  document.querySelector('#expenses-search-btn').href = `${gon.analyses_path}?period=${e.target.value}&tab=${getCurrentTabStr()}`
});

// 前後月移動ボタンと検索ボタンを配列に入れて取得
const getChangeableLinkBtns = function() {
  return [
    document.querySelector('#last-month-btn'),
    document.querySelector('#next-month-btn'),
    document.querySelector('#expenses-search-btn')
  ];
};

// ページ遷移したときに同じタブを開くようにページを遷移させるボタンにタブパラメータを付与
const setSpecifyTab = (element) => {
  const targetStr = element.id.replace('-tab-link','');
  const period = gon.current_uear_month;
  const changeableLinkBtns = getChangeableLinkBtns();
  changeableLinkBtns.forEach((btn) => {
    btn.href = `${gon.analyses_path}?period=${gon.current_year_month}&tab=${targetStr}`
  })
};

// タブをクリックしたときに、ボタンのパラメータを変更する関数をセット
const expensesTabLink = document.querySelector('#expenses-tab-link');
const budgetTabLink = document.querySelector('#budgets-tab-link');
expensesTabLink.addEventListener('click', () => {
  setSpecifyTab(event.target)
});
budgetTabLink.addEventListener('click', () => {
  setSpecifyTab(event.target)
});
