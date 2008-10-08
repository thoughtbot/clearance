module ThoughtBot # :nodoc:
  module Shoulda # :nodoc:
    module Controller # :nodoc:
      module Helpers # :nodoc:
        private # :enddoc:

        SPECIAL_INSTANCE_VARIABLES = %w{
          _cookies
          _flash
          _headers
          _params
          _request
          _response
          _session
          action_name
          before_filter_chain_aborted
          cookies
          flash
          headers
          ignore_missing_templates
          logger
          params
          request
          request_origin
          response
          session
          template
          template_class
          template_root
          url
          variables_added
        }.map(&:to_s)

        def instantiate_variables_from_assigns(*names, &blk)
          old = {}
          names = (@response.template.assigns.keys - SPECIAL_INSTANCE_VARIABLES) if names.empty?
          names.each do |name|
            old[name] = instance_variable_get("@#{name}")
            instance_variable_set("@#{name}", assigns(name.to_sym))
          end
          blk.call
          names.each do |name|
            instance_variable_set("@#{name}", old[name])
          end
        end

        def get_existing_record(res) # :nodoc:
          returning(instance_variable_get("@#{res.object}")) do |record|
            assert(record, "This test requires you to set @#{res.object} in your setup block")
          end
        end

        def make_parent_params(resource, record = nil, parent_names = nil) # :nodoc:
          parent_names ||= resource.parents.reverse
          return {} if parent_names == [] # Base case
          parent_name = parent_names.shift
          parent = record ? record.send(parent_name) : parent_name.to_s.classify.constantize.find(:first)

          { :"#{parent_name}_id" => parent.to_param }.merge(make_parent_params(resource, parent, parent_names))
        end
      end
    end
  end
end
