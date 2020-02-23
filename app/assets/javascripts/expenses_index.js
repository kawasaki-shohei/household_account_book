const periodSelect = document.querySelector('#period-select');
const categorySelect = document.querySelector('#expense-category-selection');

const getParameters = ({ periodValue, categoryValue }) => {
  if (periodValue){
    categoryValue = document.querySelector('#expense-category-selection').value;
  } else {
    periodValue = document.querySelector('#period-select').value;
  }
  let path = location.origin + location.pathname;
  if (categoryValue === "") {
    path += `?period=${periodValue}`
  } else {
    path += `?period=${periodValue}&category=${categoryValue}`
  }
  return path;
};

// 月を選択するセレクトボックスを変更したときに検索ボタンのパスを変更する
periodSelect.addEventListener('change', (e) => {
  document.querySelector('#expenses-search-btn').href = getParameters({ periodValue: e.target.value })
});

categorySelect.addEventListener('change', (e) => {
  document.querySelector('#expenses-search-btn').href = getParameters({ categoryValue: e.target.value })
});

window.onload = () => {
  if(arg.expense){
    const expense_id = arg.expense;
    const targetLi = $(`#expense-list-id-${expense_id}`);
    $('html, body').animate({scrollTop: targetLi.offset().top - 50}, 500, 'swing');
    const timelineItem = targetLi.find('.timeline-item');
    timelineItem.addClass('target-timeline-item')
  }
};