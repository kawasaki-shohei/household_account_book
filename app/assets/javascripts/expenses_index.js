const periodSelect = document.querySelector('#period-select');
// 月を選択するセレクトボックスを変更したときに検索ボタンのパスを変更する
periodSelect.addEventListener('change', (e) => {
  document.querySelector('#expenses-search-btn').href = `${location.origin + location.pathname}?period=${e.target.value}`
});

window.onload = function(){
  if(arg.expense){
    const expense_id = arg.expense;
    const target = document.querySelector(`#expense-list-id-${expense_id}`);
    const rect = target.getBoundingClientRect();
    window.scrollBy({top: rect.top - 30, behavior: "smooth"});
  }
};