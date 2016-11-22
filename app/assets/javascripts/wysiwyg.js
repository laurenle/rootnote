// Load saved note into editor
$(document).ready(function() {
  $("#editor").html($("#output").text());
});

// Update font values to where the cursor is
function updateselections() {
  // Get font elements defining color and size for start and end of selection
  // TODO: Figure out how to check children too..
  var selection1 = window.getSelection().anchorNode;
  var selection2 = window.getSelection().focusNode;
  var selection1color = selection1;
  while (selection1color && (selection1color.nodeType !== 1 || !selection1color.hasAttribute("color"))) {
    selection1color = selection1color.parentNode;
  }
  var selection2color = selection2;
  while (selection2color && (selection2color.nodeType !== 1 || !selection2color.hasAttribute("color"))) {
    selection2color = selection2color.parentNode;
  }
  var selection1size = selection1;
  while (selection1size && (selection1size.nodeType !== 1 || !selection1size.hasAttribute("size"))) {
    selection1size = selection1size.parentNode;
  }
  var selection2size = selection2;
  while (selection2size && (selection2size.nodeType !== 1 || !selection2size.hasAttribute("size"))) {
    selection2size = selection2size.parentNode;
  }
  
  // Get values
  var size = $(selection1size).attr("size") === $(selection2size).attr("size") ?
    $(selection1size).attr("size") || "2" : "-";
  var color = $(selection1color).attr("color") === $(selection2color).attr("color") ?
    $(selection1color).attr("color") || "rgb(0,0,0)" : "-";
  
  // Set selections
  $("#fontsize").val(size);
  $("#fontcolor").val(color);
}
$("#editor").mouseup(updateselections);
$("#editor").keyup(updateselections);

// Font size
function fontsize() {
  document.execCommand("fontSize", false, parseInt($("#fontsize").val()));
}

// Font color
function fontcolor() {
  document.execCommand("foreColor", false, $("#fontcolor").val());
}

// Bold
function b() {
  document.execCommand("bold", false, null);
}

// Italic
function i() {
  document.execCommand("italic", false, null);
}

// Underline
function u() {
  document.execCommand("underline", false, null);
}

// Bulleted list
function bullet() {
  document.execCommand("insertUnorderedList", false, null);
}

// Numbered list
function numbered() {
  document.execCommand("insertOrderedList", false, null);
}

// Table
function table() {
  // TODO
}

// Image
function image() {
  var url = $("#imgurl").val();
  if (url) {
    document.execCommand("insertHTML", false, '<img src="' + url + '" />');
  }
}

// Clear formatting
function clearformat() {
  document.execCommand("removeFormat", false, null);
}

// Refresh output
function refreshoutput() {
  $("#output").text($("#editor").html());
}

// Submit
function submit() {
  refreshoutput();
  $("form.edit_note").submit();
}