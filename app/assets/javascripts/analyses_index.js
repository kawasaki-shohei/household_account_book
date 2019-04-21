// 今のactiveになっているタブを取得
const getCurrentTabStr = () => {
  return `${document.querySelector('ul.nav-tabs>li.active').id.replace('-tab', '')}`
};

const yearMonthSelect = document.querySelector('#year-month-select');
// 月を選択するセレクトボックスを変更したときに検索ボタンのパスを変更する
yearMonthSelect.addEventListener('change', (e) => {
  document.querySelector('#expenses-search-btn').href = `${location.origin + location.pathname}?period=${e.target.value}&tab=${getCurrentTabStr()}`
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
const setSpecifyTab = () => {
  const targetStr = event.target.id.replace('-tab-link','');
  const changeableLinkBtns = getChangeableLinkBtns();
  changeableLinkBtns.forEach((btn) => {
    let targetHref = `${btn.href.replace(/tab=[a-z]+/, `tab=${targetStr}`)}`;
    btn.href = targetHref;
  })
};

// タブをクリックしたときに、ボタンのパラメータを変更する関数をセット
document.querySelector('#expenses-tab-link').addEventListener('click', setSpecifyTab, false);
document.querySelector('#budgets-tab-link').addEventListener('click', setSpecifyTab, false);

const expensePanelHeading = document.querySelector('#expense-panel-heading');
const icon = document.querySelector('.fa-caret-right');
expensePanelHeading.addEventListener('click', () => {
  if(icon){
    icon.classList.toggle('rotate-arrow');
  }
});

// ページ読み込み後にパラメーターでしてしたカテゴリーまでスクロールする。
window.onload = function(){
  if(arg.tab === 'expenses' && arg.category){
    const category_id = arg.category;
    const target = document.querySelector(`#expenses-comparison-category-id-${category_id}`);
    const rect = target.getBoundingClientRect();
    window.scrollBy({top: rect.top - 30, behavior: "smooth"});
  }
};

