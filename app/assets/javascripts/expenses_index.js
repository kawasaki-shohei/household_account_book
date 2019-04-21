window.onload = function(){
  if(arg.expense){
    const expense_id = arg.expense;
    const target = document.querySelector(`#expense-list-id-${expense_id}`);
    const rect = target.getBoundingClientRect();
    window.scrollBy({top: rect.top - 30, behavior: "smooth"});
  }
};