class AssetItem < ApplicationRecord
  before_create :set_asset_count
  before_save :update_asset_track, if: :user_id_changed?

  has_many :asset_item_values, dependent: :destroy
  belongs_to :asset
  belongs_to :user, optional: true
  has_many :asset_tracks
  has_many :asset_requests

  validates_uniqueness_of :asset_id, scope: [:asset_count]
  validates_presence_of :user, if: proc { |a| a.user_id.present? }
  validate :validate_item_must_be_free, on: [:update]

  accepts_nested_attributes_for :asset_item_values, allow_destroy: true

  private

  def set_asset_count
    max = asset.asset_items.pluck(:asset_count).compact.max
    self.asset_count = max ? max + 1 : 1
  end

  def update_asset_track
    if asset_tracks.empty? || user
      asset_tracks.new(user_id: user_id, assigned_on: Time.now)
    else
      asset_tracks.last.update(submitted_on: Time.now)
    end
  end

  def validate_item_must_be_free
    errors.add(:base, 'first free the asset item') if AssetItem.find(id).user.present? && user.present?
  end
end
