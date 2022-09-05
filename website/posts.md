---
layout: page
title: Posts
permalink: /posts
---

# Posts

<ul>
  {% for post in site.posts %}
    <li>
      {{ post.date | date: '[%d-%m-%y]' }} <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>