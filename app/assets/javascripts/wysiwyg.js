// Global variables
var inserttab;

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

  /* ---------- Insert menu ---------- */
  // Place insert menu
  var top = $("header").height() + $("#controls").height() + 20;
  var left = $(window).width() / 2 + 40;
  var maxheight = $("#notecontainer").height() - 40;
  $("#insertmenu").css({"top": top, "left": left, "max-height": maxheight});

  // Toggle insert menu
  var showinsert = 0;
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

  $("#image").click(function() {
    document.execCommand("insertHTML", false, '<img class="resizable" style="width: 200pt;" src="' + $("#imageurl").val() + '" />');
  });

  // Submit
  $("#save").click(function() {
    $("#note_body").text($("#editor").html());
    $("form.edit_note").submit();
  });

  // Image resizing ----------
  var hovering = 0;
  var resizing = null;
  var starty, startx, startw, starth;
  $(".resizable").hover(function() {
    hovering = 1;
    var resizable = $(this);
    if ($("#resizer").length === 0) {
      // Place resizer
      $("body").append('<div id="resizer" style="position: absolute; display: none;"></div>');
      positionresizer($(this));

      // Bind mouseleave event
      $("#resizer").mouseleave(function() {
        window.setTimeout(function() {
          if (hovering === 0 && !resizing) $("#resizer").remove();
        }, 200);
      });

      // Bind mousedown event
      $("#resizer").mousedown(function() {
        resizing = resizable;
        starty = event.pageY;
        startx = event.pageX;
        startw = resizable.width();
        starth = resizable.height();
      });
    }
  }, function() {
     hovering = 0;
     // Remove resizer
     window.setTimeout(function() {
      if ($("#resizer:hover").length === 0 && !resizing) $("#resizer").remove();
     }, 200);
  });

  // Make sure resizer is correctly positioned when scrolling
  $("#notecontainer").scroll(function() {
    positionresizer($(".resizable:hover"));
  });

  // Resize as mouse moves
  $(document).mousemove(function() {
    var wchange = event.pageX - startx;
    var hchange = event.pageY - starty;
    var neww = startw + wchange;
    var newh = starth + hchange;
    if (resizing && neww > 20 && newh > 20) {
      if (wchange > hchange) {
        resizing.css({"width": neww, "height": "auto"});
      } else {
        resizing.css({"width": "auto", "height": newh});
      }
      positionresizer(resizing);
    }
  });

  // Stop resizing on mouseup
  $(document).mouseup(function() {
    resizing = null;
    $("#resizer").remove();
  });
});

// Reposition resizer
function positionresizer(resizable) {
  if (resizable.length > 0) {
    var bottom = $(window).height() - resizable.offset().top - resizable.height();
    var right = $(window).width() - resizable.offset().left - resizable.width();
    $("#resizer").css({"bottom": bottom, "right": right, "display": "block"});
  }
}

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