class Webhooks::Outgoing::Endpoint < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :deliveries, class_name: "Webhooks::Outgoing::Delivery", dependent: :destroy, foreign_key: :endpoint_id
  has_many :events, -> { distinct }, through: :deliveries
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  scope :listening_for_event_type_id, ->(event_type_id) { where("event_type_ids @> ? OR event_type_ids = '[]'::jsonb", "\"#{event_type_id}\"") }
  # 🚅 add scopes above.

  validates :name, presence: true
  validates :url, presence: true, allowed_uri: true
  # 🚅 add validations above.

  after_save :touch_team

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_event_types
    Webhooks::Outgoing::EventType.all
  end

  def event_types
    event_type_ids.map { |id| Webhooks::Outgoing::EventType.find(id) }
  end

  # touch team to invalidate endpoints_listening_for_event_type? cache
  def touch_team
    team.touch
  end

  # 🚅 add methods above.
end
