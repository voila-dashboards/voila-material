{%- extends 'base.tpl' -%}
{% from 'mathjax.tpl' import mathjax %}

{# this overrides the default behavior of directly starting the kernel and executing the notebook #}
{% block notebook_execute %}
{% endblock notebook_execute %}

{%- block html_head_css -%}
<link href="{{resources.base_url}}voila/static/index.css" rel="stylesheet" type='text/css'>
{% if resources.theme == 'dark' %}
{% set bar_color = '#555454' %}
<link href="{{resources.base_url}}voila/static/theme-dark.css" rel="stylesheet" type='text/css'>
{% else %}
{% set bar_color = '#5cbcaf' %}
<link href="{{resources.base_url}}voila/static/theme-light.css" rel="stylesheet" type='text/css'>
{% endif %}
<link href="{{resources.base_url}}voila/static/materialize.min.css" rel="stylesheet" type='text/css'>

<style type="text/css">
  body {
    background-color: var(--jp-layout-color0);
    overflow-y: scroll;
  }

  .nav-wrapper {
    background-color: {{ bar_color }};
  }

  .brand-logo {
    height: 90%;
    width: 100%;
  }

  #loading {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 75vh;
      color: var(--jp-content-font-color1);
      font-family: sans-serif;
  }

  .spinner {
    animation: rotation 2s infinite linear;
    transform-origin: 50% 50%;
  }

  .spinner-container {
    width: 10%;
  }

  @keyframes rotation {
    from {transform: rotate(0deg);}
    to   {transform: rotate(359deg);}
  }

  .voila-spinner-color1{
    fill: {{ bar_color }};
  }

  .voila-spinner-color2{
    fill: #f8e14b;
  }

  @font-face {
    font-family: 'Material Icons';
    font-style: normal;
    font-weight: 400;
    src: url({{resources.base_url}}voila/static/icons_font.ttf) format('truetype');
  }

  .material-icons {
    font-family: 'Material Icons';
    font-weight: normal;
    font-style: normal;
    font-size: 24px;
    line-height: 1;
    letter-spacing: normal;
    text-transform: none;
    display: inline-block;
    white-space: nowrap;
    word-wrap: normal;
    direction: ltr;
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
{%- block body_header -%}
<body data-base-url="{{resources.base_url}}voila/">
  <div id="loading">
    <div class="spinner-container">
      <svg class="spinner" data-name="c1" version="1.1" viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title>voila</dc:title></cc:Work></rdf:RDF></metadata><title>spin</title><path class="voila-spinner-color1" d="m250 405c-85.47 0-155-69.53-155-155s69.53-155 155-155 155 69.53 155 155-69.53 155-155 155zm0-275.5a120.5 120.5 0 1 0 120.5 120.5 120.6 120.6 0 0 0-120.5-120.5z"/><path class="voila-spinner-color2" d="m250 405c-85.47 0-155-69.53-155-155a17.26 17.26 0 1 1 34.51 0 120.6 120.6 0 0 0 120.5 120.5 17.26 17.26 0 1 1 0 34.51z"/></svg>
    </div>
    <h5 id="loading_text">Running {{nb_title}}...</h5>
  </div>
<script>
var voila_process = function(cell_index, cell_count) {
  var el = document.getElementById("loading_text")
  el.innerHTML = `Executing ${cell_index} of ${cell_count}`
}
</script>

<div id="rendered_cells" style="display: none">
{%- endblock body_header -%}

  <header>
    <div class="navbar-fixed">
      <nav class="top-nav">
        <div class="nav-wrapper">
          <a href="#!" class="brand-logo-container">
            <object class="brand-logo" type="image/svg+xml" data="{{ resources.base_url }}voila/static/voila_logo.svg"></object>
          </a>
          <ul class="right">
            <li><a href="#"><i class="material-icons" id="kernel-status-icon">radio_button_unchecked</i></a></li>
          </ul>
        </div>
      </nav>
    </div>
  </header>

  <main>
    <div class="container">
      <div class="row">
        <div class="col s12">
          {% if resources.theme == 'dark' %}
          <div class="jp-Notebook theme-dark">
          {% else %}
          <div class="jp-Notebook theme-light">
          {% endif %}
            {%- block body_loop -%}
              {# from this point on, the kernel is started #}
              {%- with kernel_id = kernel_start() -%}
                <script id="jupyter-config-data" type="application/json">
                {
                    "baseUrl": "{{resources.base_url}}",
                    "kernelId": "{{kernel_id}}"
                }
                </script>
                {% set cell_count = nb.cells|length %}
                {%- for cell in cell_generator(nb, kernel_id) -%}
                  {% set cellloop = loop %}
                  {%- block any_cell scoped -%}
                  <script>
                    voila_process({{ cellloop.index }}, {{ cell_count }})
                  </script>
                    {{ super() }}
                  {%- endblock any_cell -%}
                {%- endfor -%}
              {% endwith %}
            {%- endblock body_loop -%}
            <div id="rendered_cells" style="display: none">
          </div>
        </div>
      </div>
    </div>
  </main>

{%- block body_footer -%}
  <script type="text/javascript">
    (function() {
      // remove the loading element
      var el = document.getElementById("loading")
      el.parentNode.removeChild(el)
      // show the cell output
      el = document.getElementById("rendered_cells")
      el.style.display = 'unset'
    })();
  </script>

  <script src="{{resources.base_url}}voila/static/materialize.min.js"></script>
</body>
{%- endblock body_footer -%}

{% block footer_js %}
  {{ super() }}

  <script type="text/javascript">
    requirejs(['static/voila'], function(voila) {
      (async function() {
        var kernel = await voila.connectKernel();

        kernel.statusChanged.connect(() => {
          // console.log(kernel.status);
          var el = document.getElementById("kernel-status-icon");

          if (kernel.status == 'busy') {
            el.innerHTML = 'radio_button_checked';
          } else {
            el.innerHTML = 'radio_button_unchecked';
          }
        });
      })();
    });
  </script>
{% endblock footer_js %}

{%- endblock body -%}
