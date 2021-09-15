{% macro render(post) %}

  <article class="post post-type-{{ post.type | default('normal') }}" itemscope itemtype="http://schema.org/Article">
    <header class="post-header">

      <{% if theme.seo %}h3{% else %}h2{% endif %} class="post-title">
        {% if post.link %}{# Link posts #}
          <a class="post-title-link post-title-link-external" target="_blank" href="{{ url_for(post.link) }}" itemprop="url">
            {{ post.title or post.link }}
            <i class="fa fa-external-link"></i>
          </a>
        {% else %}
            <a class="post-title-link" href="{{ url_for(post.path) }}" itemprop="url">
              {% if post.type === 'picture' %}
                {{ post.content }}
              {% else %}
                <span itemprop="name" class="archive-title" updated="{{ date(post.updated, config.date_format) }}">{{ post.title | default(__('post.untitled')) }}</span>
                {% if theme.leancloud_visitors.enable %}
                  <span id="{{ url_for(post.path) }}" class="leancloud_visitors" data-flag-title="{{ post.title }}">
                    <span class="post-meta-divider">|</span>
                    <span class="post-meta-item-icon">
                      <i class="fa fa-eye"></i>
                    </span>
                    {% if theme.post_meta.item_text %}
                      <span class="post-meta-item-text">{{__('post.visitors')}} </span>
                    {% endif %}
                      <span class="leancloud-visitors-count"></span> ℃
                  </span>
                {% endif %}
              {% endif %}
            </a>
        {% endif %}
      </{% if theme.seo %}h3{% else %}h2{% endif %}>

      <div class="post-meta">
        <time class="post-time" itemprop="dateCreated"
              datetime="{{ moment(post.date).format() }}"
              content="{{ date(post.date, config.date_format) }}" >
          {{ date(post.date, 'MM-DD') }}
        </time>
      </div>

    </header>
  </article>

{% endmacro %}
