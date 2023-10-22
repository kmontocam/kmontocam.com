function toggleCollapsedMenu(label) {
  const checkbox = document.getElementById(label);
  checkbox.checked = false;

  const changeEvent = new Event("change");
  checkbox.dispatchEvent(changeEvent);
}

function changeDomLanguage(lang) {
  document.documentElement.lang = lang;
}
