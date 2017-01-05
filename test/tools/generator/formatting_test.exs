defmodule ESTree.Tools.Generator.Formatting.Test do
  use ShouldI

  alias ESTree.Tools.Builder
  import ESTree.Test.Support

  should "format objects" do
    ast = Builder.program([
      Builder.function_declaration(
        Builder.identifier(:test),
        [],
        [],
        Builder.block_statement([
          Builder.variable_declaration([
            Builder.variable_declarator(Builder.identifier(:a)),
            Builder.variable_declarator(Builder.identifier(:b)),
            Builder.variable_declarator(
              Builder.identifier(:c),
              Builder.function_expression(
                [],
                [],
                Builder.block_statement([
                  Builder.return_statement(Builder.literal(1))
                ])
              )
            )
          ]),
          Builder.if_statement(
            Builder.literal(true),
            Builder.block_statement([
              Builder.expression_statement(
                Builder.assignment_expression(
                  :=,
                  Builder.identifier(:a),
                  Builder.literal(-1)
                )
              )
            ])
          ),
          Builder.switch_statement(
            Builder.literal(false),
            [
              Builder.switch_case(
                nil,
                [
                  Builder.expression_statement(
                    Builder.assignment_expression(
                      :=,
                      Builder.identifier(:b),
                      Builder.literal(0)
                    )
                  ),
                  Builder.break_statement()
                ]
              )
            ]
          ),
          Builder.return_statement(
            Builder.object_expression([
              Builder.property(
                Builder.identifier(:a),
                Builder.binary_expression(
                  :+,
                  Builder.identifier(:a),
                  Builder.literal(1)
                )
              ),
              Builder.property(
                Builder.identifier(:b),
                Builder.binary_expression(
                  :+,
                  Builder.identifier(:b),
                  Builder.literal(2)
                )
              ),
              Builder.property(
                Builder.identifier(:c),
                Builder.binary_expression(
                  :+,
                  Builder.identifier(:c),
                  Builder.literal(3)
                )
              )
            ])
          )
        ])
      ),
      Builder.expression_statement(
        Builder.call_expression(
          Builder.identifier(:test),
          []
        )
      )
    ])

    str = """
function test() {
    var a,
        b,
        c = function() {
            return 1;
        };

    if (true) {
        a = -1;
    }

    switch (false) {
    default:
        b = 0;
        break;
    }

    return {
        a: a + 1,
        b: b + 2,
        c: c + 3
    };
}

test();
"""

    assert_gen ast, String.trim(str)

    str = "function test(){var a,b,c=function(){return 1;};if(true){a=-1;}switch(false){default:b=0;break;}return {a:a+1,b:b+2,c:c+3};}test();"

    assert_gen ast, str, beauty: false
  end
end
