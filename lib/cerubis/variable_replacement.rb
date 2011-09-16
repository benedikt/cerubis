class Cerubis
  module VariableReplacement
    def replace_variables(str, ctx)
      str.gsub(Matcher::Variable) do |variable|
        match_var = variable.match(Matcher::Variable)[1]
        if match = match_var.match(Matcher::Helpers)
          helper_method = match[1]
          helper_method_sym = helper_method.to_sym
          helper_args   = match[2].to_s.split(Matcher::CommaOutsideQuote).map do |arg|
            ctx.get(arg.strip)
          end

          begin
            if helper_mod = Cerubis.helpers[helper_method_sym]
              helper = Helper.new
              helper.extend helper_mod

              if helper.public_methods.include? helper_method
                helper.send(helper_method_sym, *helper_args)
              end
            end
          rescue ArgumentError
            raise SyntaxError, "A wrong number of arguments were passed to '#{helper_method}'"
          end
        else
          ctx.get(match_var)
        end
      end
    end
  end
end
