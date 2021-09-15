{% if theme.valine_modify.enable and theme.valine_modify.appid and theme.valine_modify.appkey %}
  <script src="https://cdn.lishaoy.net/js/av-min.js"></script>
  {# <script src='//unpkg.com/valine/dist/Valine.min.js'></script> #}
  <script src='https://cdn.lishaoy.net/js/Valine.min.js'></script>

  <script type="text/javascript">
    var GUEST = ['nick','mail','link'];
    var guest = '{{ theme.valine.guest_info }}';
    guest = guest.split(',').filter(item=>{
      return GUEST.indexOf(item)>-1;
    });
    new Valine({
        av: AV,
        el: '#comments' ,
        appId: '{{ theme.valine_modify.appid }}',
        appKey: '{{ theme.valine_modify.appkey }}',
        placeholder: '{{ theme.valine_modify.placeholder }}',
        avatar: 'retro'
    });
  </script>
{% endif %}
