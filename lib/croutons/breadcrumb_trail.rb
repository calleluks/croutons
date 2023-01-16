require 'ruby2_keywords'
require 'croutons/breadcrumb'

module Croutons
  class BreadcrumbTrail
    def self.breadcrumbs(*args)
      new(*args).breadcrumbs
    end

    attr_reader :breadcrumbs

    def initialize(template_identifer, objects = {})
      @template_identifer = template_identifer
      @objects = objects.with_indifferent_access
      @breadcrumbs = []
      build_breadcrumbs
    end

    def method_missing(name, *args)
      if respond_to_missing?(name)
        Rails.application.routes.url_helpers.public_send(name, *args)
      else
        super
      end
    end

    def respond_to_missing?(name)
      Rails.application.routes.url_helpers.respond_to?(name)
    end

    private

    attr_reader :template_identifer, :objects

    def build_breadcrumbs
      send(template_identifer)
      labelize_last
    end

    def labelize_last
      breadcrumbs.last.try(:labelize)
    end

    def breadcrumb(*args)
      breadcrumbs << Breadcrumb.new(*args)
    end

    ruby2_keywords def t(*args)
      I18n.t(*args)
    end
  end
end
