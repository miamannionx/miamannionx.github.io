---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Home
permalink: /
---

# Welcome to my website!

This is currently a work in progress, but I intend on displaying my portfolio here, alongside some blog posts.

Please enjoy!

Take a look at some of my [posts](/posts) and projects: 

<ul>
  {% for post in site.posts %}
    <li>
      {{ post.date | date: '[%d-%m-%y]' }} <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
