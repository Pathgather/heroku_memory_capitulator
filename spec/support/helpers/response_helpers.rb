# frozen_string_literal: true

module SpecHelpers
  module ResponseHelpers
    def response_json
      JSON.parse(response.body)
    end

    # accepts a path relative to /spec/fixtures folder
    def read_fixtures(path:)
      path = File.join(Rails.root.join('spec','fixtures'), path)
      File.open(path, 'rb').read
    end
  end
end
