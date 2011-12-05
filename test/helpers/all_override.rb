class Foo
  def self.zing(args)
    puts *args
  end
end

class OverRideAll
  include Commandeer

  command "random", :parent => 'override', :klass => "Foo", :parser => "zing"
end
