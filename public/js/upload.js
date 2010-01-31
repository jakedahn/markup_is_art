$(document).ready(function(){
  $("#adjustment").hide();
  $("a#save").hide();
  $("#uploadForm").validate();
    
    $("#mustache").draggable({
      opacity: 0.65,
      containment: 'parent',
      stop: function(event, ui) {
        $("a#save").show();
      }
    });
        
    var resizeOptions = {
      url: "/up",
      success: function(res){
        full_res = res;
        temp_image = JSON.parse(res).url;

        $("#adjustment").css("background", "url("+temp_image+")").attr("alt", full_res);
        $("#adjustment").show();
      } 
    };
    $('#uploadForm').submit(function() { 
      $(this).ajaxSubmit(resizeOptions); 
      
      return false; 
    }); 

    $("a#save").click(function(){
      var data = JSON.parse($("#adjustment").attr("alt"));
      data.position = getOffset($("#mustache"));

      $.ajax({
        type: 'POST',
        url: "/upload",
        data: data,
        success: function(res){
          window.location.replace(res);
        }
      });
    })
});

function showRequest(formData, jqForm, options) { 
    var queryString = $.param(formData);
    console.log('About to submit: \n\n' + queryString);

    return true;
}

function getOffset(element) {
  var parentPos = $("#mustache").parent().position()
  var currentPos = $("#mustache").position();
  var position = {
    x: currentPos.left-parentPos.left,
    y: currentPos.top-parentPos.top
  }
  return position;
}
