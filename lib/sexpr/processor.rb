require_relative 'processor/helper'
require_relative 'processor/sexpr_coercions'
module Sexpr
  class Processor

    ### class methods

    def self.helper_chain
      @helper_chain ||= superclass.helper_chain.dup rescue nil
    end

    def self.register_helper(helper)
      if @helper_chain
        @helper_chain.append helper
      else
        @helper_chain = helper
      end
    end

    def self.helper(helper_class)
      helper_class.install_on(self)
    end

    ### instance methods

    attr_reader :main_processor

    def initialize(options = {})
      @main_processor = options.delete(:main_processor) || self
    end

    def call(sexpr)
      help(sexpr) do |n|
        meth = :"on_#{n.first}"
        meth = :"on_missing" unless respond_to?(meth)
        send(meth, n)
      end
    end

    def on_missing(sexpr)
      raise UnexpectedSexprError, "Unexpected sexpr: #{sexpr.inspect}"
    end

    private

    def help(sexpr)
      if helper_chain = self.class.helper_chain
        helper_chain.call(self, sexpr) do |_,n|
          yield(n)
        end
      else
        yield(sexpr)
      end
    end

  end # class Processor
end # module Sexpr