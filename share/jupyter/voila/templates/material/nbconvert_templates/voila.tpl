{%- extends 'base.tpl' -%}
{% from 'mathjax.tpl' import mathjax %}

{%- block html_head_css -%}
<link href="{{resources.base_url}}voila/static/index.css" rel="stylesheet" type='text/css'>
<link href="{{resources.base_url}}voila/static/theme-light.css" rel="stylesheet" type='text/css'>
<link href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css" rel="stylesheet" type='text/css'>

<style type="text/css">
  .body {
    background-color: var(--jp-layout-color0);
  }

  .brand-logo {
    height: 90%;
    width: 100%;
  }
</style>

{% for css in resources.inlining.css %}
    <style type="text/css">
    {{ css }}
    </style>
{% endfor %}

<style>
a.anchor-link {
  display: none;
}
.highlight  {
  margin: 0.4em;
}
</style>

{{ mathjax() }}
{%- endblock html_head_css -%}

{%- block body -%}
<body class="body" data-base-url="{{resources.base_url}}voila/">
  <header>
    <div class="navbar-fixed">
      <nav class="top-nav">
        <div class="nav-wrapper grey lighten-5">
          <a href="#!" class="brand-logo-container">
            <object class="brand-logo" type="image/svg+xml" data="{{resources.base_url}}voila/static/voila.svg"></object>
          </a>
        </div>
      </nav>
    </div>
  </header>

  <main>
    <div class="container">
      <div class="row">
        <div class="col s12">
          <div class="jp-Notebook theme-light">
            {{ super() }}
          </div>
        </div>
      </div>
    </div>
  </main>
</body>
{%- endblock body -%}

