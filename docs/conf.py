# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'My Dev Config'
copyright = '2023, hotchilipowder'
author = 'hotchilipowder'


intersphinx_mapping = {
    "python": ("https://docs.python.org/3", None),
    "sphinx": ("https://www.sphinx-doc.org/en/master", None),
}

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

# use this https://github.com/lepture/shibuya/blob/9da45f1af8d031639d18773314c6e722c2dd412c/docs/conf.py

extensions = [
    "myst_parser",
    "sphinx.ext.autodoc",
    "sphinx.ext.intersphinx",
    "sphinx.ext.extlinks",
    "sphinx.ext.todo",
    "sphinx.ext.viewcode",
    "sphinxcontrib.mermaid",
    "sphinx_tabs.tabs",
    "sphinxemoji.sphinxemoji",
    "sphinx_copybutton",
    "sphinx_design",
    "sphinx_comments"

]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

language = 'zh'

comments_config = {
   "utterances": {
      "repo": "hotchilipowder/my_config",
      "optional": "config",
   }
}

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'shibuya'
html_static_path = ['_static']

html_logo = "_static/my_config.png"
html_title = 'My Dev Config'
html_favicon = "_static/logo.svg"
html_theme_options = {
    "logo_target": "/my_config",
    "github_url": "https://github.com/hotchilipowder/my_config",
    'light_logo': "_static/my_config.png",
    "dark_logo": "_static/my_config_dark.png",
    "nav_links": [
    ]
}
html_copy_source = False
html_show_sourcelink = False

html_context = {
    "source_type": "github",
    "source_user": "hotchilipowder",
    "source_repo": "my_config",
}

html_css_files = [
 "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"
]



latex_engine = 'xelatex'
latex_elements = {
  'preamble': r'''
\addto\captionsenglish{\renewcommand{\chaptername}{}}
\usepackage[UTF8, scheme = plain]{ctex}
''',
}
