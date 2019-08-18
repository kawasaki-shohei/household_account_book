// 今のactiveになっているタブを取得
const getCurrentTabStr = () => {
  return `${document.querySelector('ul.nav-tabs>li.active').id.replace('-tab', '')}`
};

const periodSelect = document.querySelector('#period-select');
// 月を選択するセレクトボックスを変更したときに検索ボタンのパスを変更する
periodSelect.addEventListener('change', (e) => {
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

// ページ読み込み後にパラメーターで指定したカテゴリーまでスクロールする。
// todo: スクロールしたあとに、指定したカテゴリーを強調する処理を入れないとわかりにくい。
window.onload = () => {
  if(arg.category){
    const category_id = arg.category;
    let target;
    if (arg.tab === 'expenses') {
      target = $(`#expenses-comparison-category-id-${category_id}`)[0];
    } else {
      target = $(`#budgets-comparison-category-id-${category_id}`)[0];
    }
    $('html, body').animate({scrollTop: target.offsetTop - 30}, 500, 'swing');
  }
};

