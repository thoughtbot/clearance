require "spec_helper"
require "generators/clearance/specs/specs_generator"

describe Clearance::Generators::SpecsGenerator, :generator do
  it "copies specs to host app" do
    run_generator

    specs = %w(
      factories/clearance
      features/clearance/user_signs_out_spec
      features/clearance/visitor_resets_password_spec
      features/clearance/visitor_signs_in_spec
      features/clearance/visitor_signs_up_spec
      features/clearance/visitor_updates_password_spec
      support/clearance
      support/features/clearance_helpers
    )

    spec_files = specs.map { |spec| file("spec/#{spec}.rb") }

    spec_files.each do |spec_file|
      expect(spec_file).to exist
      expect(spec_file).to have_correct_syntax
    end
  end
end
