require 'redis'

require 'sidekiq/util'

require 'sidekiq/scheduler'
require 'sidekiq-scheduler/schedule'

module SidekiqScheduler

  # The delayed job router in the system.  This
  # manages the scheduled jobs pushed messages
  # from Redis onto the work queues
  #
  class Manager
    include Sidekiq::Util

    def initialize(options)
      enabled = Sidekiq::Scheduler.enabled
      Sidekiq::Scheduler.enabled = enabled.nil? && options[:enabled] || enabled
      Sidekiq::Scheduler.dynamic = options[:dynamic]
      Sidekiq.schedule = options[:schedule] if options[:schedule]
    end

    def stop
      Sidekiq::Scheduler.clear_schedule!
    end

    def start
      Sidekiq::Scheduler.load_schedule!
    end

    def reset
      clear_scheduled_work
    end

  end

end
