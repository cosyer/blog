{#
{% if theme.baidu_push %}
<script>
(function(){
    var bp = document.createElement('script');
    var curProtocol = window.location.protocol.split(':')[0];
    if (curProtocol === 'https') {
        bp.src = '/js/src/push.js';
    }
    else {
        bp.src = '/js/src/push.js';
    }
    var l = document.getElementsByTagName("script").length - 1;
    var s = document.getElementsByTagName("script")[l];
    s.parentNode.insertBefore(bp, s);
})();
</script>
{% endif %}
#}
