python
------

.. dropdown:: [pybname]  input the header

   .. code-block:: bash

        #!/usr/bin/env python3
        #-*- coding: utf-8 -*-
        """
        @author: ${1:huangjunjie}
        `!p
        import datetime
        import vim
        import os
        date_now = datetime.datetime.now().strftime('%Y/%m/%d')
        filename = os.path.basename(vim.current.buffer.name)
        snip.rv = f'''@file: {filename}
        @time: {date_now}'''
        `
        """
        
        $0

    
latex
-----

.. dropdown:: [dm]  Math

   .. code-block:: bash

        \[
        $1
        .\] $0

    

.. dropdown:: [today]  Date

   .. code-block:: bash

        endsnippet
        
        
        
        snippet box "Box"
        `!p snip.rv = '┌' + '─' * (len(t[1]) + 2) + '┐'`
        │ $1 │
        `!p snip.rv = '└' + '─' * (len(t[1]) + 2) + '┘'`
        $0

    

.. dropdown:: [tttbegin]  xelatex begin

   .. code-block:: bash

        % !TeX program = xelatex

    

.. dropdown:: [tt]  The \texttt{} command for typewriter-style font

   .. code-block:: bash

        endsnippet
        
        
        snippet ff "The LaTeX \frac{}{} command"
        \frac{$1}{$2}$0

    

.. dropdown:: [hr]  The hyperref package's \href{}{} command (for url links)

   .. code-block:: bash

        endsnippet
        
        snippet "(^|[^a-zA-Z])mi" "Inline LaTeX math" rA
        `!p snip.rv = match.group(1)`\$${1:${VISUAL:}} \$$0

    

.. dropdown:: [snippet]  (?<![\\a-zA-Z])([a-zA-Z])\1{1}(?![a-zA-Z ])

   .. code-block:: bash

        `!p transliteration = {"a": "\\alpha", "b": "\\beta", "g": "\\gamma", "G": "\\Gamma", "d": "\\delta", "D": "\\Delta", "e": "\\epsilon", "E": "\\varepsilon", "z": "\\zeta", "h": "\\eta", "t": "\\theta", "T": "\\Theta", "k": "\\kappa", "i": "\\iota", "l": "\\lambda", "L": "\\Lambda", "n": "\\nu", "x": "\\xi", "X": "\\Xi", "p": "\\pi", "P": "\\Pi", "r": "\\rho", "s": "\\sigma", "S": "\\Sigma", "o": "\\omega", "O": "\\Omega", "c": "\\chi", "f": "\\phi", "F": "\\Phi", "y": "\\upsilon", "Y": "\\Upsilon", "v": "\\psi", "V": "\\Psi", "u": "\\tau" }
        m = match.group(1)
        if m in transliteration:
        	snip.rv = transliteration[m]`$0 

    

.. dropdown:: [hello]  test for python

   .. code-block:: bash

        `!p snip.rv="hello world"`

    
restructuredtext
----------------

.. dropdown:: [h2]  Description

   .. code-block:: bash

        $1
        ######################################
        
        $2

    

.. dropdown:: [codeblock]  Description

   .. code-block:: bash

        .. code-block:: ${1:type}
          :linenos:
          ${2:code}
        

    

.. dropdown:: [list]  Description

   .. code-block:: bash

        * ${1:this} 
        
        * ${2:this}
        
        * ${3:this}

    

.. dropdown:: [xref]  Description

   .. code-block:: bash

        :xref:\`$1\`

    

.. dropdown:: [test]  Description

   .. code-block:: bash

        ${1:${VISUAL:test}}

    

.. dropdown:: [ablog_new]  ablog new

   .. code-block:: bash

        `!p snip.rv = display_width(t[1])*'='`
        ${1:${VISUAL:Chapter name}}
        `!p snip.rv = display_width(t[1])*'='`
        
        $0

    

.. dropdown:: [ablognote_new]  ablog new

   .. code-block:: bash

        `!v strftime("%Y-%m-%d")` ${1:${VISUAL:Section name}}
        `!p snip.rv = 11 * '*' + display_width(t[1])*'*'`
        
        $0

    
