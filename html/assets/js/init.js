const open = (data) => {
  $('#name').css('color', '#282828');

  $('#name').text(data.name);
  $('#rank').text(data.rank);
  $('#csi').text(data.csi);

  $('#id-card').css('background', 'url(assets/images/lspd.png)');

  $('#id-card').show();
}

const close = () => {
  $('#name').text('');
  $('#rank').text('');
  $('#csi').text('');
  $('#signature').text('');
  $('#id-card').hide();
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                open(event.data);
                break;
            case "close":
                close();
                break;
        }
    })
});
