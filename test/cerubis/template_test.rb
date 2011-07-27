require 'test_helper'

class Cerubis::TemplateTest < MiniTest::Unit::TestCase
  def test_returns_template_content
    content  = 'template content'
    template = Cerubis::Template.new(content)

    assert_equal content, template.content
  end

  def test_returns_template_context
    context  = { foo: true, bar: false}
    template = Cerubis::Template.new('', context)

    assert_equal context, template.context
  end

  def test_node_stucture
    template = Cerubis::Template.new(content)

    assert_equal '<body>', template.nodes[0].render.strip
    assert_equal '<section>Foo Content</section>', template.nodes[1].render.strip
    assert_equal '</body>', template.nodes[2].render.strip
  end

  def test_parse_single_block
    template = Cerubis::Template.new(content)
    html = Capybara::Node::Simple.new(template.to_html)

    assert html.has_selector?('body > section', content: 'Foo Content')
  end

  private
    def content
      <<-STR
        <body>
        {{#if true}}
          <section>Foo Content</section>
        {{/if}}
        </body>
      STR
    end
end
