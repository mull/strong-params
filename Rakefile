require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  task :with_settings do
    require "active_record"
    unless ENV["DATABASE_URL"]
      require "dotenv"
      Dotenv.load
    end
  end

  task c: :with_settings do
    exec "psql #{ENV.fetch('DATABASE_URL')}"
  end

  task drop: :with_settings do
    `dropdb #{ENV.fetch("DATABASE_NAME")}`
  end

  task create: :with_settings do
    `createdb #{ENV.fetch("DATABASE_NAME")}`
  end

  task migrate: :with_settings do
    ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL'))

    ActiveRecord::Schema.define do
      create_table :posts, force: true do |t|
        # Implicit ID
        t.string :title, null: false
        t.text :body, null: false

        # TODO: Test default on this
        t.string :tags, array: true, null: false

        t.datetime :created_at, null: false
        t.datetime :updated_at, null: false
      end

      create_table :all_types, force: :true do |t|
        # Implicit ID
        [:string, :text, :integer, :bigint, :float, :decimal, :numeric, :datetime, :time, :date, :binary, :boolean].each do |type|
          t.send(type, "#{type}_nullable".to_sym, null: true)
          t.send(type, "#{type}_not_nullable".to_sym, null: false)

          t.send(type, "#{type}_array_nullable".to_sym, null: true, array: true)
          t.send(type, "#{type}_array_not_nullable".to_sym, null: false, array: true)
        end

        t.integer :fake_enum_nullable, null: true
        t.integer :fake_enum_not_nullable, null: false
      end
    end

    puts "Migrated"
  end

  task setup: :with_settings do
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
