module ThoughtBot # :nodoc:
  module Shoulda # :nodoc:
    module Helpers
      # Prints a message to stdout, tagged with the name of the calling method.
      def report!(msg = "")
        puts("#{caller.first}: #{msg}")
      end
    end
  end
end
