function clearContents(element) {
  if (element.value.match(/IPv6 separated by new line/)) {
    element.value = '';
  }
}

function setDefault(element) {
  if (element.value.match(/^\s*$/)) {
    element.value = "IPv6 separated by new line";
  }
}
