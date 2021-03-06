# Sexpr

[![Build Status](https://secure.travis-ci.org/blambeau/sexpr.png)](http://travis-ci.org/blambeau/sexpr)
[![Dependency Status](https://gemnasium.com/blambeau/sexpr.png)](https://gemnasium.com/blambeau/sexpr)

A ruby compilation framework around s-expressions.

## Links

https://github.com/blambeau/sexpr

## Features/Problems

* Provides a YAML format for describing grammars (abstract syntax trees, more precisely).
* Provides a simple way to check the validity of a s-expression against a given grammar.
* Provides a framework for processing and rewriting abstract syntax trees.
* Focusses on the semantic pass, not the syntactic one.
* Smoothly, yet not tightly, integrates with the Citrus PEG parser (for the syntactic pass).

## Example

    # Let load a grammar defined in YAML
    grammar = SexpGrammar.load(<<-YAML)
      rules:
        # alternative rule
        bool_expr:
          - bool_and
          - bool_or
          - bool_not
          - var_ref
          - bool_lit

        # non-terminal
        bool_and:
          - [ bool_expr, bool_expr ]
        bool_or:
          - [ bool_expr, bool_expr ]
        bool_not:
          - [ bool_expr ]
        bool_lit:
          - [ truth_value ]
        var_ref:
          - [ var_name ]

        # terminals
        var_name:
          !ruby/regexp /^[a-z]+$/
        truth_value:
          - true
          - false
    YAML

### Checking the structure of s-expressions

    # the grammar can be used to verify the structure of s-expressions
    grammar === [:bool_and, [:bool_not, [:var_ref, "x"]], [:bool_lit, true]]
    # => true

    grammar === [:bool_and, [:bool_lit, "true"]]
    # => false (second term is missing)

### Including s-expression tools

    # the grammar can also be used to automatically have support on top of
    # such s-expressions
    expr = grammar.sexpr([:bool_lit, true])

    Sexpr === expr
    # => true

    expr.sexpr_type
    # => :bool_lit

    expr.sexpr_body
    # => [true]

    # Rewriting s-expressions through copying is easy...
    copy = expr.sexpr_copy do |base,child|
      # copy a s-expression ala Enumerable#inject (base is [:bool_lit] initially)
      base << [:bool_lit, !child]
    end
    # => [:bool_lit, [:bool_lit, false]]

    # ... and is tag preserving (including User-included modules)
    Sexpr === copy
    # true

### Where to read next?

Have a look at the examples directory.