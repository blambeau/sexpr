require_relative "sexpr/version"
require_relative "sexpr/loader"
require_relative "sexpr/errors"
#
# A helper to manipulate sexp grammars
#
module Sexpr

  def self.load(input)
    case input
    when lambda{|x| x.respond_to?(:to_path)}
      require 'yaml'
      yaml = YAML.load_file(input.to_path)
      load yaml.merge(:path => input)
    when String
      require 'yaml'
      load YAML.load(input)
    when Hash
      Grammar.new(input)
    else
      raise ArgumentError, "Invalid argument for Sexpr::Grammar: #{input}"
    end
  end

end # module Sexpr
require_relative "sexpr/grammar"
require_relative "sexpr/matcher"
require_relative "sexpr/parser"