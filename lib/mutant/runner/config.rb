module Mutant
  class Runner
    # Runner for object config
    class Config < self

      register Mutant::Config

      # Run runner for object
      #
      # @param [Config] config
      # @param [Object] object
      #
      # @return [Runner]
      #
      # @api private
      #
      def self.run(config)
        handler = lookup(config.class)
        handler.new(config)
      end

      # Return subject runners
      #
      # @return [Enumerable<Runner::Subject>]
      #
      # @api private
      #
      attr_reader :subjects

      # Return failed subjects
      #
      # @return [Enumerable<Subject>]
      #
      # @api private
      #
      def failed_subjects
        subjects.reject(&:success?)
      end
      memoize :failed_subjects

      # Test if run was successful
      #
      # @return [true]
      #   if run was successful
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def success?
        failed_subjects.empty?
      end
      memoize :success?

      # Return strategy
      #
      # @return [Strategy]
      #
      # @api private
      #
      def strategy
        config.strategy
      end

    private

      # Run config
      #
      # @return [undefined]
      #
      # @api private
      #
      def run_subjects
        strategy = self.strategy
        strategy.setup
        @subjects = dispatch(config.subjects)
        strategy.teardown
      end

      # Run with strategy management
      #
      # @return [undefined]
      #
      # @api private
      #
      def run
        report(config)
        run_subjects
        @end = Time.now
        report(self)
      end

    end # Config
  end # Runner
end # Mutant
