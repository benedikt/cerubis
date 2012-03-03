class Cerubis
  module VariableReplacement
    def replace_variables(str, ctx=context)
      str.gsub(Matcher::Variable) do |variable|
        match_var = variable.match(Matcher::Variable)[1]
        if match = match_var.match(Matcher::Helpers)
          helper_method = match[1]
          helper_args   = match[2].to_s.split(Matcher::CommaOutsideQuote).map do |arg|
            ctx.get(arg.strip)
          end

          call_helper(helper_method, helper_args, ctx)
        else
          call_helper(match_var, [], ctx) || ctx.get(match_var)
        end
      end
    end

  private

    def call_helper(name, arguments = [], ctx = context)
      if helper_mod = Cerubis.helpers[name.to_sym]
        helper = Helper.new(ctx)
        helper.extend helper_mod

        if helper.respond_to?(name)
          helper.send(name, *arguments)
        end
      end
    rescue ArgumentError
      raise SyntaxError, "A wrong number of arguments were passed to '#{name}'"
    end
  end
end
