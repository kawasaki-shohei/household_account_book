const yearMonthSelect = document.querySelector('#year-month-select');
yearMonthSelect.addEventListener('change', (e) => {
  document.querySelector('#expenses-search-btn').href = `${gon.analyses_path}?period=${e.target.value}`
});