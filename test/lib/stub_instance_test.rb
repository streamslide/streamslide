require 'test_helper'

describe Object do
  class SimpleObject
    def foo
      "foo"
    end
  end

  it "stub instance method" do
    SimpleObject.instance_stub :foo, "bar" do
      obj = SimpleObject.new
      assert_equal "bar", obj.foo
    end
  end

  it "instance cannot call instance_stub" do
    obj = SimpleObject.new
    assert_equal false, obj.respond_to?(:instance_stub)
  end
end
