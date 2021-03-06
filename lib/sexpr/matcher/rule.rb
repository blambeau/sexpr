module Sexpr
  module Matcher
    class Rule
      include Matcher

      attr_reader :name
      attr_reader :defn

      def initialize(name, defn)
        @name = name
        @defn = defn
      end

      def match?(sexp)
        defn.match?(sexp)
      end

      def eat(sexp)
        defn.eat(sexp)
      end

      def inspect
        "(rule #{name}, #{defn.inspect})"
      end

    end # class Rule
  end # module Matcher
end # module Sexpr
