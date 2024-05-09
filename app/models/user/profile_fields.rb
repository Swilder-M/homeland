# frozen_string_literal: true

class User
  module ProfileFields
    extend ActiveSupport::Concern

    included do
      delegate :contacts, to: :profile, allow_nil: true
      delegate :theme, to: :profile, allow_nil: true
    end

    def profile_field(field)
      return nil if contacts.nil?
      contacts[field.to_s]
    end

    def full_profile_field(field)
      v = profile_field(field)
      prefix = Profile.contact_field_prefix(field)
      return v if prefix.blank?
      [prefix, v].join("")
    end

    def update_theme(value)
      create_profile if profile.blank?
      profile.update(theme: value)
    end

    def update_profile_fields(field_values)
      val = contacts || {}
      field_values.each do |key, value|
        next unless Profile.has_field?(key)
        val[key.to_s] = value
      end

      create_profile if profile.blank?
      profile.update(contacts: val)
    end

    private

  end
end
