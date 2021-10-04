# frozen_string_literal: true

module Settings
  # Security rules plan export settings
  class PlanPolicy < ApplicationPolicy
    attr_reader :user, :plan

    def initialize(user, plan)
      raise Pundit::NotAuthorizedError, 'must be logged in' unless user

      super(user)
      @user = user
      @plan = plan
    end

    def show?
      @plan.readable_by(@user.id)
    end

    def update?
      @plan.editable_by(@user.id)
    end
  end
end
