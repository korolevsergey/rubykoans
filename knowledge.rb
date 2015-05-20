class Module
  def attribute(attr, &block)
    case attr
    when Hash
      name = attr.keys.first
      default = attr[name]
    when String, Symbol
      name = attr
      default = nil
    end

    method_name = name.to_sym

    define_method(:"#{name}?") do
      !!send(method_name)
    end

    define_method(:"#{name}=") do |attr|
      instance_variable_set(:"@#{name}", attr)
    end

    define_method(method_name) do
      if instance_variable_defined?(:"@#{name}")
        instance_variable_get(:"@#{name}")
      else
        block ? instance_eval(&block) : default
      end
    end
  end
end
