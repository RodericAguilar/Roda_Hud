

window.addEventListener("message", function(event) {
    var noti = event.data.noti
    var evento = event.data
    if (noti == true) {
        $('#logo2').attr('src', evento.logo);
        $('.servername').html(evento.name);
        $('#hearthlevel').css('width', evento.health+ '%');
        $('#shieldlevel').css('width', evento.fuel+ '%');
        $('#waterlevel').css('width', evento.thirst+ '%');
        $('#comidalevel').css('width', evento.food+ '%'); 
        $('#staminalevel').css('width', evento.stamina+ '%'); 
        $('.idbro').html(evento.playerid);
        $('#hudmain').fadeIn(200);
        $('#movee').draggable();
        $('#logo2').draggable();
    }else {
        $('#hudmain').fadeOut(200)
    }


});



$(document).keyup((e) => {
    if (e.key === "Escape") {
        setTimeout(() => {
            $.post('https://Roda_Hud/exit', JSON.stringify({}));
        }, 300);
    }
});


