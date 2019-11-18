module RT
  Light = Struct.new(:position, :intensity) do
    def initialize(*)
      super
      freeze
    end
  end
end
