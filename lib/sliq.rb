require 'slim'
require 'sliq/version'
require 'tilt/liquid'

module Sliq
  class Parser < Slim::Parser
    define_options attr_list_delims: {
      '(' => ')',
      '[' => ']'
    }

    def unknown_line_indicator
      case @line
      when /\A%\s*(\w+)/
        @line = $'
        parse_liquid_tag($1)
      when /\A\{/
        block = [:multi]
        @stacks.last << [:multi, [:slim, :interpolate, @line], block]
        @stacks << block
      else
        super
      end
    end

    def parse_liquid_tag(name)
      block = [:multi]
      @stacks.last << [:liquid, :tag, name, @line.strip, block]
      @stacks << block
    end
  end

  class Tags < Slim::Filter
    def on_liquid_tag(name, args, block)
      expr = [:static, "{% #{name} #{args} %}"]
      expr = [:multi, expr, block ] unless empty_exp?(block)
      expr
    end
  end

  class Interpolation < Slim::Interpolation
    def on_slim_attrvalue(escape, code)
      if code =~ /\A\{\{.*\}\}\Z/
        [:static, code]
      else
        [:slim, :attrvalue, escape, code]
      end
    end

    def on_slim_interpolate(string)
      block = [:multi]
      begin
        case string
        when /\A\\{\{/
          # Escaped interpolation
          block << [:static, '{{']
          string = $'
        when /\A\{{2}((?>[^{}]|(\{{2}(?>[^{}]|\g<1>)*\}{2}))*)\}{2}/
          # Interpolation
          string, code = $', $1
          escape = code !~ /\A\{.*\}\Z/
          block << [:slim, :output, escape, escape ? code : code[1..-2], [:multi]]
        # TODO: make reg exp for liquid static text
        when /\A([#\\]?[^#\\]*([#\\][^\\#\{][^#\\]*)*)/
          # Static text
          block << [:static, $&]
          string = $'
        end
      end until string.empty?
      block
    end
  end

  class Engine < Slim::Engine
    replace Slim::Parser, Parser, Parser.options
    before Slim::Interpolation, Interpolation
    after Parser, Tags
  end

  Converter = Temple::Templates::Tilt(Engine)

  class Template < Tilt::Template
    def prepare
      @converter = Converter.new(options) { data }
    end

    def evaluate(scope, locals, &block)
      liquid = @converter.render(scope, locals, &block)
      Tilt::LiquidTemplate.new(options) { liquid }.render(scope, locals, &block)
    end
  end
end

Tilt.register(Sliq::Template, 'sliq')
