module Travis
  module Conditions
    module V1
      class Eval < Struct.new(:sexp, :data)
        def apply
          !!evl(sexp)
        end

        private

          def evl(expr)
            cast(send(*expr))
          end

          def not(lft)
            !evl(lft)
          end

          def or(lft, rgt)
            evl(lft) || evl(rgt)
          end

          def and(lft, rgt)
            evl(lft) && evl(rgt)
          end

          def eq(lft, rgt)
            evl(lft) == evl(rgt)
          end

          def not_eq(lft, rgt)
            not eq(lft, rgt)
          end

          def match(lft, rgt)
            evl(lft) =~ evl(rgt)
          end

          def not_match(lft, rgt)
            not match(lft, rgt)
          end

          def in(lft, rgt)
            rgt = rgt.map { |rgt| evl(rgt) }
            rgt.include?(evl(lft))
          end

          def is(lft, rgt)
            send(rgt, evl(lft))
          end

          def val(str)
            str
          end

          def reg(str)
            Regexp.new(str)
          end

          def var(name)
            data[name]
          end

          def call(name, args)
            send(name, *args.map { |arg| evl(arg) })
          end

          def env(key)
            data.env(key)
          end

          def present(value)
            value.respond_to?(:empty?) && !value.empty?
          end

          def blank(value)
            !present(value)
          end

          def true(value)
            !!value
          end

          def false(value)
            !value
          end

          def cast(obj)
            case obj.to_s.downcase
            when 'false'
              false
            when 'true'
              true
            else
              obj
            end
          end
      end
    end
  end
end
