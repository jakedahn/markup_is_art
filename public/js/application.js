$(function(){
  $("ul.vote li").click(function(){
    var image_id = $(this.parentNode).attr("id");
    var type = $(this).attr("class");
    
    if (type == "up") {
      $("ul#"+image_id+" li.up").addClass("active");
      $("ul#"+image_id+" li.down").addClass("inactive");
    }else {
      $("ul#"+image_id+" li.up").addClass("inactive");
      $("ul#"+image_id+" li.down").addClass("active");
    }
    
    $.ajax({
      type: "POST",
      url: "/vote/"+image_id+"/"+type,
    });
    
    console.log(image_id);
  })
});
  // $.post('/vote', {"_id": this.id,"_rev": this.title,"task":$(this).text(),"done": false}