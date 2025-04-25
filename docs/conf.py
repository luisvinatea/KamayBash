# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
import os
import sys
sys.path.insert(0, os.path.abspath(
    '../apps/nautilus-extensions/copy_location'))
sys.path.insert(0, os.path.abspath(
    '../apps/nautilus-extensions/flatten_folder'))
sys.path.insert(0, os.path.abspath('../apps/nautilus-extensions/merge_csv'))
sys.path.insert(0, os.path.abspath('../apps/nautilus-extensions/merge_doc'))
sys.path.insert(0, os.path.abspath('../apps/nautilus-extensions/merge_pdf'))
sys.path.insert(0, os.path.abspath('../apps/nautilus-extensions/merge_ppt'))
sys.path.insert(0, os.path.abspath(
    '../apps/nautilus-extensions/organize_by_extension'))

PROJECT = 'KamayBash'
COPYRIGHT = '2025, Luis Vinatea'
AUTHOR = 'Luis Vinatea'
RELEASE = '2025'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

HTML_THEME = 'sphinx_rtd_theme'
html_static_path = ['_static']
