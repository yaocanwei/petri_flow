# frozen_string_literal: true

# == Schema Information
#
# Table name: wf_arcs
#
#  id            :integer          not null, primary key
#  workflow_id   :integer
#  transition_id :integer
#  place_id      :integer
#  direction     :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  guards_count  :integer          default("0")
#

module Wf
  class Arc < ApplicationRecord
    belongs_to :workflow, touch: true
    belongs_to :transition
    belongs_to :place

    has_many :guards, dependent: :destroy

    scope :with_guards, -> { where("guards_count > 0") }
    scope :without_guards, -> { where(guards_count: 0) }

    # direction is relative to the transition
    enum direction: {
      in: 0,
      out: 1
    }

    def name
      if in?
        [place&.name, transition&.name].join(" -> ")
      else
        [transition&.name, place&.name].join(" -> ")
      end
    end
  end
end
