class Cerubis
  autoload :Node,        'cerubis/node'
  autoload :TextNode,    'cerubis/text_node'
  autoload :BlockNode,   'cerubis/block_node'
  autoload :Matcher,     'cerubis/matcher'
  autoload :Template,    'cerubis/template'
  autoload :Parser,      'cerubis/parser'
  autoload :Condition,   'cerubis/condition'
  autoload :Context,     'cerubis/context'
  autoload :SyntaxError, 'cerubis/syntax_error'

  def self.render(template, context={})
    new.render(template, context)
  end

  def render(template, context={})
    Template.new(template, context)
  end
end
