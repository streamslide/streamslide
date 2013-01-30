# Add new method for stub
# Minitest only support stub for class method
#
# Ex:
#
#   class SimpleObject
#     def foo
#       "foo"
#     end
#   end
#
# If we want to mock foo method of SimpleObject, we do like this
#
#   obj = SimpleObject.new
#   obj.stub :foo, "bar" do
#     # some code in here
#   end
#
# This library add new method `instance_stub` for every class, which stub a method
# for every instance of class.
# To stub method foo in SimpleObject, we do
#
#   SimpleObject.instance_stub :foo, "bar" do
#     obj = SimpleObject.new
#     assert_equal "bar", obj.foo
#   end
#
class Class
  def instance_stub name, val_or_callable, &block
    new_name = "__minitest_stub__#{name}"

    metaclass = self

    if respond_to? name and not methods.map(&:to_s).include? name.to_s then
      metaclass.send :define_method, name do |*args|
        super(*args)
      end
    end

    metaclass.send :alias_method, new_name, name

    metaclass.send :define_method, name do |*args|
      if val_or_callable.respond_to? :call then
        val_or_callable.call(*args)
      else
        val_or_callable
      end
    end

    yield self
  ensure
    metaclass.send :undef_method, name
    metaclass.send :alias_method, name, new_name
    metaclass.send :undef_method, new_name
  end
end
