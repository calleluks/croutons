module Croutons
  module Controller
    def self.included(controller)
      controller.helper do
        def breadcrumbs(objects = {})
          begin
            breadcrumb_trail = ::BreadcrumbTrail
          rescue NameError
            raise NotImplementedError,
              'Define a `BreadcrumbTrail` class that inherits from '\
              '`Breadcrumbs::BreadcrumbTrail`, or override the '\
              '`breadcrumb_trail` method in your controller so that it '\
              'returns an object that responds to `#breadcrumbs`.'
          end

          template_identifier = @virtual_path.gsub('/', '_')
          objects.reverse_merge!(controller.view_assigns)
          breadcrumbs = breadcrumb_trail.breadcrumbs(template_identifier, objects)
          render(
            partial: 'breadcrumbs/breadcrumbs',
            locals: { breadcrumbs: breadcrumbs },
          )
        end
      end
    end
  end
end
