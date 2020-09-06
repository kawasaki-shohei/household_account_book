window.onload = () => {
  document.querySelector('#demo-btn').click();
  document.querySelectorAll('a').forEach( (aTag) => {
    aTag.addEventListener('click', (event) => {
      event.preventDefault();
    })
  })
};