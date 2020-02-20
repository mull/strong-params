class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Post < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
end

class AllTypes < ApplicationRecord
  ENUM_OPTIONS_FAKE = { low: 0, medium: 1, high: 2 }.freeze

  enum fake_enum_nullable: ENUM_OPTIONS_FAKE, _prefix: :buggy_
  enum fake_enum_not_nullable: ENUM_OPTIONS_FAKE, _prefix: :more_buggy_
end

