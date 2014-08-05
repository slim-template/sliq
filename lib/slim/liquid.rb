require 'slim'
require 'tilt/liquid'
require 'slim/liquid/version'

module Slim
  module Liquid
    class Parser < ::Slim::Parser
      set_default_options :attr_list_delims => {
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

    class Tags < ::Slim::Filter
      def on_liquid_tag(name, args, block)
        if empty_exp?(block)
          [:static, "{% #{name} #{args} %}"]
        else
          [:multi,
           [:static, "{% #{name} #{args} %}\n"],
           block,
           [:static, "\n{% end#{name} %}"]]
        end
      end
    end

    class Interpolation < ::Slim::Interpolation
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
          when /\A\{/
            string, code = parse_expression($')
            block << [:escape, false, [:slim, :interpolate, "{#{code}}"]]
          when /\A([^\{]*)/
            block << [:slim, :interpolate, $&]
            string = $'
          end
        end until string.empty?
        block
      end
    end

    class Engine < ::Slim::Engine
      replace Slim::Parser, Parser, :file, :tabsize, :shortcut, :default_tag, :attr_delims, :attr_list_delims, :code_attr_delims
      before ::Slim::Interpolation, Interpolation
      after Parser, Tags
    end

    Converter = Temple::Templates::Tilt(Engine)

    class Template < Tilt::Template
      def prepare
        @converter = Converter.new(options) { data }
      end

      def evaluate(scope, locals, &block)
        liquid = @converter.render(scope, locals, &block)
        ::Tilt::LiquidTemplate.new(options) { liquid }.render(scope, locals, &block)
      end
    end
  end
end
