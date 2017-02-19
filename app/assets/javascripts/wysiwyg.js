// Global variables
var inserttab;
var hovering;
var resizing;
var starty, startx, startw, starth;
var level, progress;
var levelcolors = ["#f44b42", "#f48f41", "#e2dd41", "#55ba51", "#4cb5f7", "#b858ef"];

$(document).ready(function() {
  /* ---------- Setup ---------- */
  // Load saved note into editor
  $("#editor").html($("#note_body").text());

  // Bind selection events
  $("#editor").mouseup(updateselections);
  $("#editor").keyup(updateselections);

  // Disable tabbing away from editor
  $("#editor").keydown(function(e) {
    if (e.key === "Tab") {
      e.preventDefault();
      document.execCommand("indent", false, null);
    }
  });

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
  $("#insertmenu").css({"top": top, "left": left});
  $(".insertpage").css("max-height", maxheight);

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
  changetab("upload");
  $("#uploadtab").click(function() {
    changetab("upload");
  });
  $("#pdftab").click(function() {
    changetab("pdf");
  });

  // Add loading cover while AJAX is happening on any insert menu page
  $(".insertpage").on("ajax:before", function() {
    $(this).append('<div class="loadingcover"></div>');
  });
  $(".insertpage").on("ajax:complete", function() {
    $(this).find(".loadingcover").remove();
  });

  // Bind insert menu events
  bindinsertevents("upload");
  bindinsertevents("pdf");

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
    $("form.edit_note").submit();
  });

  /* ---------- Image resizing ---------- */
  hovering = false;
  resizing = null;
  $(".resizable").hover(resizableenter, resizableleave);

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
    if (resizing) {
      resizing = null;
      $("#resizer").remove();
    }
  });

  /* ---------- Productivity meter ---------- */
  level = 0;
  progress = 0;
  startover = false;

  $("#meter #text").html("Level " + level);
  $("#meter #filled").css("background", levelcolors[level % 6]);

  // Things that change progress
  $(window).blur(function() {
    startover = true;
  });
  $("#editor").keypress(function() {
    progress += 0.4;
  });

  // Update meter every second
  setInterval(function() {
    if (startover) {
      level = 0;
      progress = 0;
      $("#meter #text").html("Level 0: Started over :(");
    }

    if (progress > 100) {
      progress -= 100;
      level++;
      $("#meter #text").html("Level " + level);
      $("#meter #filled").css("background", levelcolors[level % 6]);
    }

    $("#meter #filled").css("width", progress + "%");
  }, 2000);
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

// Reposition resizer
function positionresizer(resizable) {
  if (resizable.length > 0) {
    var bottom = $(window).height() - resizable.offset().top - resizable.height();
    var right = $(window).width() - resizable.offset().left - resizable.width();
    $("#resizer").css({"bottom": bottom, "right": right, "display": "block"});
  }
}

// Hover over resizable
function resizableenter() {
  hovering = true;
  var resizable = $(this);
  if ($("#resizer").length === 0) {
    // Place resizer
    $("body").append('<div id="resizer" style="position: absolute; display: none;"></div>');
    positionresizer($(this));

    // Bind mouseleave event
    $("#resizer").mouseleave(function() {
      window.setTimeout(function() {
        if (!hovering && !resizing) $("#resizer").remove();
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
}

// Stop hovering over resizable
function resizableleave() {
   hovering = false;
   // Remove resizer
   window.setTimeout(function() {
    if ($("#resizer:hover").length === 0 && !resizing) $("#resizer").remove();
   }, 200);
}

// Change insert tab
function changetab(newtab) {
  $("#insert" + inserttab).css("display", "none");
  $("#" + inserttab + "tab").removeClass("selected");
  inserttab = newtab;
  $("#insert" + inserttab).css("display", "block");
  $("#" + inserttab + "tab").addClass("selected");
}

// Function for binding everything inside the insert menu renders
// Consolidated here because we need to do this on document ready and whenever AJAX updates the render
function bindinsertevents(insertable_name) {
  // Delete confirmation
  $(".delete-" + insertable_name).submit(function() {
    var form = $(this);
    var button = $(this).find(".delete");

    if (button.hasClass("confirm")) {
      return true;  // Submit
    }

    // Confirm deletion
    button.val("Sure?");
    button.addClass("confirm");

    // Revert if they stop hovering
    $(this).closest("." + insertable_name).mouseleave(function() {
      button.val("Delete");
      button.removeClass("confirm");
    });

    return false;  // Don't submit
  });

  // AJAX file submission
  // For some reason rails refuses to do this for us
  $("#" + insertable_name + "-form").on("ajax:aborted:file", function() {
    $("#" + insertable_name + "-form").trigger("ajax:before");

    var formdata = new FormData($("#" + insertable_name + "-form").get(0));
    $.ajax({
      url: "/" + insertable_name + "s",
      type: "POST",
      data: formdata,
      dataType: "script",
      contentType: false,
      processData: false
    });

    return false;  // Override regular submission
  });

  // Insert image
  $("#insert" + insertable_name + " .insert").click(function() {
    var address = $(this).closest(".insertable").data("address");
    document.execCommand("insertHTML", false, '<img class="new resizable" style="width: 200pt;" src="' + address + '" />');
    $(".new.resizable").hover(resizableenter, resizableleave).removeClass("new");
  });

  // Insert PDF table
  if (insertable_name === "pdf") {
    $(".insertpdftable").click(function() {
      // Construct HTML
      var html = '<table class="pdftable">';
      $("#pdfcontainer .insertable").each(function() {
        var address = $(this).data("address");
        html += '<tr><td class="page" contentEditable="false"><img src="' + address + '" /></td><td></td></tr>';
      });
      html += '</table>';

      // Insert table at end of editor so they can't put it somewhere weird
      $("#editor").append(html);
    });
  }
}