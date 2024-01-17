python
------
latex
-----

.. dropdown:: [tttbegin]  xelatex begin

   .. code-block:: bash

        % !TeX program = xelatex

    

.. dropdown:: [snippet]  (^|[^a-zA-Z])mi

   .. code-block:: bash

        `!p snip.rv = match.group(1)`\$${1:${VISUAL:}} \$$0

    

.. dropdown:: [hello]  test for python

   .. code-block:: bash

        `!p snip.rv="hello world"`

    
restructuredtext
----------------

.. dropdown:: [xref]  Description

   .. code-block:: bash

        :xref:\`$1\`

    

.. dropdown:: [test]  Description

   .. code-block:: bash

        ${1:${VISUAL:test}}

    
