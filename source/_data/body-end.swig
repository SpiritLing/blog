<script src="//api-1253449676.file.myqcloud.com/hexo-tsevsRE3DqdsEmPl/js-3wZifnDxAp4vw7h6/hexo-custom-body-end-v-0.0.1.4c5e58d95014812dcf076d114d0b44e2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lobibox@1.2.7/dist/js/lobibox.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lobibox@1.2.7/dist/js/notifications.min.js"></script>
<script src="http://47.102.200.249:10002/randomSentence?callback=customeNotice"></script>
<script>
$.ajax({
    type: "GET",
    url: "http://47.102.200.249:10002/randomSentence",
    success: function(data){
        if(data.status){
            Lobibox.notify.OPTIONS = $.extend({}, Lobibox.notify.OPTIONS, {
                default: {
                    'class': 'lobibox-notify-custom',
                    'title': data.author,
                    sound: false
                },
            });
            Lobibox.notify('default', {
                delay: false,
                icon: false,
                msg: data.content
            });
        }
    }
});
function customeNotice(data){
    console.log(data);
    if(data.status){
        Lobibox.notify.OPTIONS = $.extend({}, Lobibox.notify.OPTIONS, {
            default: {
                'class': 'lobibox-notify-custom',
                'title': data.author,
                sound: false
            },
        });
        Lobibox.notify('default', {
            delay: false,
            icon: false,
            msg: data.content
        });
    }
}

</script>