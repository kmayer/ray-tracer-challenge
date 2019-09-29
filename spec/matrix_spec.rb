module RT
  RSpec.describe Matrix do
    describe "refinements" do
      it "always creates frozen matrices" do
        expect(Matrix.identity(4)).to be_frozen
        expect(Matrix.translation(0, 0, 0)).to be_frozen
        expect(Matrix.scaling(0, 0, 0)).to be_frozen
        expect(Matrix.rotation_z(0)).to be_frozen
        expect(Matrix.rotation_x(0)).to be_frozen
        expect(Matrix.rotation_y(0)).to be_frozen
        expect(Matrix.shearing(0, 0, 0, 0, 0, 0)).to be_frozen
        expect(Matrix.identity(4) * Matrix.identity(4)).to be_frozen
        expect(Matrix.identity(4) * Point[0, 0, 0]).to be_frozen
        expect(Matrix.identity(4).minor(0, 0)).to be_frozen
      end
    end
  end
end
