// Global variables
var inserttab;
var showinsert;

$(document).ready(function() {
  /* ---------- Setup ---------- */
  // Load saved note into editor
  $("#editor").html($("#note_body").text());

  // Bind selection events
  $("#editor").mouseup(updateselections);
  $("#editor").keyup(updateselections);

  // Style color selections (just for fun)
  $("#fontcolor option").each(function() {
    $(this).css("background", $(this).val());
  });

  // Size note container
  var height = $(window).height() - $("header").height() - $("#controls").height();
  $("#notecontainer").css("height", height);

  // Place insert menu
  var top = $("header").height() + $("#controls").height() + 20;
  var left = $(window).width() / 2 + 40;
  var maxheight = $("#notecontainer").height() - 40;
  $("#insertmenu").css({"top": top, "left": left, "max-height": maxheight});

  // Toggle insert menu
  showinsert = 0;
  $("#insert").click(function() {
    if (showinsert === 0) {
      showinsert = 1;
      $("#insertmenu").css("display", "block");
      $("#insert").text("Hide insert menu");
    } else {
      showinsert = 0;
      $("#insertmenu").css("display", "none");
      $("#insert").text("Show insert menu");
    }
  });

  // Insert menu tab switching
  changetab("image");
  $("#imagetab").click(function() {
    changetab("image");
  });
  $("#phonetab").click(function() {
    changetab("phone");
  });
  $("#pdftab").click(function() {
    changetab("pdf");
  });

  /* ---------- WYSIWYG functions ---------- */
  // Font size
  $("#fontsize").change(function() {
    document.execCommand("fontSize", false, parseInt($("#fontsize").val()));
  });

  // Font color
  $("#fontcolor").change(function() {
    document.execCommand("foreColor", false, $("#fontcolor").val());
  });


  // Bold
  $("#bold").click(function() {
    document.execCommand("bold", false, null);
  });

  // Italic
  $("#italic").click(function() {
    document.execCommand("italic", false, null);
  });

  // Underline
  $("#underline").click(function() {
    document.execCommand("underline", false, null);
  });

  // Bulleted list
  $("#bulletedlist").click(function() {
    document.execCommand("insertUnorderedList", false, null);
  });

  // Numbered list
  $("#numberedlist").click(function() {
    document.execCommand("insertOrderedList", false, null);
  });

  // Clear formatting
  $("#clearformat").click(function() {
    document.execCommand("removeFormat", false, null);
  });

  // Submit
  $("#save").click(function() {
    $("#note_body").text($("#editor").html());
    if ($("form.edit_note")) console.log("Found form");
    $("form.edit_note").submit();
  });
});

// Update font values to where the cursor is
function updateselections() {
  // Get font elements defining color and size for start and end of selection
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

// Change insert tab
function changetab(newtab) {
  $("#insert" + inserttab).css("display", "none");
  $("#" + inserttab + "tab").removeClass("selected");
  inserttab = newtab;
  $("#insert" + inserttab).css("display", "block");
  $("#" + inserttab + "tab").addClass("selected");
}