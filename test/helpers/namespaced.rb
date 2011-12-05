module Name
  class Spaced
    include Commandeer

    command "namespaced"

    def self.parse(args)
      puts args
      exit
    end
  end
end
