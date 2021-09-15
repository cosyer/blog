{% extends '_layout.swig' %}
{% import '_macro/post-collapse.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}{{ __('title.archive') }} | {{ config.title }}{% endblock %} | {{ __('title.tag') }}: {{ page.tag }}

{% block page_class %} page-archive {% endblock %}

{% block content %}

  {#################}
  {### TAG BLOCK ###}
  {#################}
  <div class="post-block per-tag">

    <div id="posts" class="posts-expand">

      <div class="tag-cloud">
            <div class="tag-cloud-title">
                {{ _p('counter.tag_cloud', site.tags.length) }}
            </div>
            <div class="tag-cloud-tags">
              {{ tagcloud({min_font: 14, max_font: 25, amount: 200, color: true, start_color: '#f6f6f6', end_color: '#87daff'}) }}
            </div>
      </div>
    </div>

  </div>
  {#####################}
  {### END TAG BLOCK ###}
  {#####################}

    <div class="post-block per-categories">
      {% include '_partials/page-header.swig' %}
      <div class="post-body">
        <div class="category-all-page">
                <div class="category-all-title">
                    {{ _p('counter.categories', site.categories.length) }}
                </div>
                <div class="category-all">
                  {{ list_categories() }}
                </div>
        </div>
      </div>
    </div>

  {#####################}
  {### ARCHIVE BLOCK ###}
  {#####################}
  <div class="post-block archive">
    <div id="posts" class="posts-collapse ">
      <span class="archive-move-on"></span>

      <span class="archive-page-counter">
        {% set cheers %}
        {% set posts_length = site.posts.length %}
        {% if posts_length > 210 %} {% set cheers = 'excellent' %}
          {% elif posts_length > 130 %} {% set cheers = 'great' %}
          {% elif posts_length > 80 %} {% set cheers = 'good' %}
          {% elif posts_length > 50 %} {% set cheers = 'nice' %}
          {% elif posts_length > 30 %} {% set cheers = 'ok' %}
        {% else %}
          {% set cheers = 'um' %}
        {% endif %}
        {{ __('cheers.' + cheers) }}! {{ _p("counter.archive_posts", site.posts.length) }} {{ __('keep_on') }}
      </span>

      {% for post in page.posts %}

        {# Show year #}
        {% set year %}
        {% set post.year = date(post.date, 'YYYY') %}
        {% set updated = date(post.updated, 'YYYY-MM-DD') %}

        {% if post.year !== year %}
          {% set year = post.year %}
          <div class="collection-title">
            <h2 class="archive-year motion-element" id="archive-year-{{ year }}">{{ year }}</h2>
          </div>
        {% endif %}
        {# endshow #}

        {{ post_template.render(post) }}

      {% endfor %}

    </div>
  </div>
  {#########################}
  {### END ARCHIVE BLOCK ###}
  {#########################}

  {% include '_partials/pagination.swig' %}

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}


{% block script_extra %}
  {% if theme.use_motion %}
    <script type="text/javascript" id="motion.page.archive">
    $(function(){
      $('.archive-year').velocity('transition.slideLeftIn');
    });
    </script>
  {% endif %}
{% endblock %}
