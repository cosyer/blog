{% extends '_layout.swig' %}
{% import '_macro/post-collapse.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% import '_macro/post.swig' as post_template_post %}

{% block title %}{{ __('title.tag') }}: {{ page.tag }} | {{ config.title }}{% endblock %}

{% block content %}
      <div class="collection-title-per">
        <{% if theme.seo %}h2{% else %}h1{% endif %}>
          {{ page.tag }}
          <span>{{  __('title.tag')  }}</span>
        </{% if theme.seo %}h2{% else %}h1{% endif %}>
      </div>

      <section id="posts" class="posts-expand">
        {% for post in page.posts %}
          {{ post_template_post.render(post, true) }}
        {% endfor %}
      </section>


  {#################}
  {### TAG BLOCK ###}
  {#################}

{#
  <div class="post-block tag">

    <div id="posts" class="posts-collapse">
      <div class="collection-title">
        <{% if theme.seo %}h2{% else %}h1{% endif %}>
        {{ page.tag }}
        <small>{{  __('title.tag')  }}</small>
        </{% if theme.seo %}h2{% else %}h1{% endif %}>
      </div>


      {% for post in page.posts %}
        {{ post_template.render(post) }}
      {% endfor %}
    </div>

  </div>
#}
  {#####################}
  {### END TAG BLOCK ###}
  {#####################}
  {% include '_partials/pagination.swig' %}
{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}
