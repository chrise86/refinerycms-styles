module Refinery
  module Style
    module Admin
      module DynamicFieldsHelper
        def link_to_remove_fields(name, f, options = {})
          f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", options)
        end
        
        def link_to_add_fields(name, f, association, options = {})
          fields = get_new_fields(f, association)
          link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", options)
        end

        def get_new_fields(f, association)
          new_object = f.object.class.reflect_on_association(association).klass.new
          f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
            render(association.to_s.singularize + "_fields", :f => builder)
          end
        end
      end
    end
  end
end
