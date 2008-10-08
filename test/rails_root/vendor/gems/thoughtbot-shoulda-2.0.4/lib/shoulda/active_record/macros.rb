module ThoughtBot # :nodoc:
  module Shoulda # :nodoc:
    module ActiveRecord # :nodoc:
      module MacroHelpers # :nodoc:
        # Helper method that determines the default error message used by Active
        # Record.  Works for both existing Rails 2.1 and Rails 2.2 with the newly
        # introduced I18n module used for localization.
        #
        #   default_error_message(:blank)
        #   default_error_message(:too_short, :count => 5)
        #   default_error_message(:too_long, :count => 60)
        def default_error_message(key, values = {})
          if Object.const_defined?(:I18n) # Rails >= 2.2
            I18n.translate("activerecord.errors.messages.#{key}", values)
          else # Rails <= 2.1.x
            ::ActiveRecord::Errors.default_error_messages[key] % values[:count]
          end
        end
      end

      # = Macro test helpers for your active record models
      #
      # These helpers will test most of the validations and associations for your ActiveRecord models.
      #
      #   class UserTest < Test::Unit::TestCase
      #     should_require_attributes :name, :phone_number
      #     should_not_allow_values_for :phone_number, "abcd", "1234"
      #     should_allow_values_for :phone_number, "(123) 456-7890"
      #
      #     should_protect_attributes :password
      #
      #     should_have_one :profile
      #     should_have_many :dogs
      #     should_have_many :messes, :through => :dogs
      #     should_belong_to :lover
      #   end
      #
      # For all of these helpers, the last parameter may be a hash of options.
      #
      module Macros
        include MacroHelpers

        # <b>DEPRECATED:</b> Use <tt>fixtures :all</tt> instead
        #
        # Loads all fixture files (<tt>test/fixtures/*.yml</tt>)
        def load_all_fixtures
          warn "[DEPRECATION] load_all_fixtures is deprecated.  Use `fixtures :all` instead."
          fixtures :all
        end

        # Ensures that the model cannot be saved if one of the attributes listed is not present.
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.blank')</tt>
        #
        # Example:
        #   should_require_attributes :name, :phone_number
        #
        def should_require_attributes(*attributes)
          message = get_options!(attributes, :message)
          message ||= default_error_message(:blank)
          klass = model_class

          attributes.each do |attribute|
            should "require #{attribute} to be set" do
              assert_bad_value(klass, attribute, nil, message)
            end
          end
        end

        # Ensures that the model cannot be saved if one of the attributes listed is not unique.
        # Requires an existing record
        #
        # Options:
        # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.taken')</tt>
        # * <tt>:scoped_to</tt> - field(s) to scope the uniqueness to.
        #
        # Examples:
        #   should_require_unique_attributes :keyword, :username
        #   should_require_unique_attributes :name, :message => "O NOES! SOMEONE STOELED YER NAME!"
        #   should_require_unique_attributes :email, :scoped_to => :name
        #   should_require_unique_attributes :address, :scoped_to => [:first_name, :last_name]
        #
        def should_require_unique_attributes(*attributes)
          message, scope = get_options!(attributes, :message, :scoped_to)
          scope = [*scope].compact
          message ||= default_error_message(:taken)

          klass = model_class
          attributes.each do |attribute|
            attribute = attribute.to_sym
            should "require unique value for #{attribute}#{" scoped to #{scope.join(', ')}" unless scope.blank?}" do
              assert existing = klass.find(:first), "Can't find first #{klass}"
              object = klass.new
              existing_value = existing.send(attribute)

              if !scope.blank?
                scope.each do |s|
                  assert_respond_to object, :"#{s}=", "#{klass.name} doesn't seem to have a #{s} attribute."
                  object.send("#{s}=", existing.send(s))
                end
              end
              assert_bad_value(object, attribute, existing_value, message)

              # Now test that the object is valid when changing the scoped attribute
              # TODO:  There is a chance that we could change the scoped field
              # to a value that's already taken.  An alternative implementation
              # could actually find all values for scope and create a unique
              # one.
              if !scope.blank?
                scope.each do |s|
                  # Assume the scope is a foreign key if the field is nil
                  object.send("#{s}=", existing.send(s).nil? ? 1 : existing.send(s).next)
                  assert_good_value(object, attribute, existing_value, message)
                end
              end
            end
          end
        end

        # Ensures that the attribute cannot be set on mass update.
        #
        #   should_protect_attributes :password, :admin_flag
        #
        def should_protect_attributes(*attributes)
          get_options!(attributes)
          klass = model_class

          attributes.each do |attribute|
            attribute = attribute.to_sym
            should "protect #{attribute} from mass updates" do
              protected = klass.protected_attributes || []
              accessible = klass.accessible_attributes || []

              assert protected.include?(attribute.to_s) ||
                (!accessible.empty? && !accessible.include?(attribute.to_s)),
                     (accessible.empty? ?
                       "#{klass} is protecting #{protected.to_a.to_sentence}, but not #{attribute}." :
                       "#{klass} has made #{attribute} accessible")
            end
          end
        end

        # Ensures that the attribute cannot be changed once the record has been created.
        #
        #   should_have_readonly_attributes :password, :admin_flag
        #
        def should_have_readonly_attributes(*attributes)
          get_options!(attributes)
          klass = model_class

          attributes.each do |attribute|
            attribute = attribute.to_sym
            should "make #{attribute} read-only" do
              readonly = klass.readonly_attributes || []

              assert readonly.include?(attribute.to_s),
                     (readonly.empty? ?
                       "#{klass} attribute #{attribute} is not read-only" :
                       "#{klass} is making #{readonly.to_a.to_sentence} read-only, but not #{attribute}.")
            end
          end
        end

        # Ensures that the attribute cannot be set to the given values
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.invalid')</tt>
        #
        # Example:
        #   should_not_allow_values_for :isbn, "bad 1", "bad 2"
        #
        def should_not_allow_values_for(attribute, *bad_values)
          message = get_options!(bad_values, :message)
          message ||= default_error_message(:invalid)
          klass = model_class
          bad_values.each do |v|
            should "not allow #{attribute} to be set to #{v.inspect}" do
              assert_bad_value(klass, attribute, v, message)
            end
          end
        end

        # Ensures that the attribute can be set to the given values.
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Example:
        #   should_allow_values_for :isbn, "isbn 1 2345 6789 0", "ISBN 1-2345-6789-0"
        #
        def should_allow_values_for(attribute, *good_values)
          get_options!(good_values)
          klass = model_class
          good_values.each do |v|
            should "allow #{attribute} to be set to #{v.inspect}" do
              assert_good_value(klass, attribute, v)
            end
          end
        end

        # Ensures that the length of the attribute is in the given range
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:short_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.too_short') % range.first</tt>
        # * <tt>:long_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.too_long') % range.last</tt>
        #
        # Example:
        #   should_ensure_length_in_range :password, (6..20)
        #
        def should_ensure_length_in_range(attribute, range, opts = {})
          short_message, long_message = get_options!([opts], :short_message, :long_message)
          short_message ||= default_error_message(:too_short, :count => range.first)
          long_message  ||= default_error_message(:too_long, :count => range.last)

          klass = model_class
          min_length = range.first
          max_length = range.last
          same_length = (min_length == max_length)

          if min_length > 0
            should "not allow #{attribute} to be less than #{min_length} chars long" do
              min_value = "x" * (min_length - 1)
              assert_bad_value(klass, attribute, min_value, short_message)
            end
          end

          if min_length > 0
            should "allow #{attribute} to be exactly #{min_length} chars long" do
              min_value = "x" * min_length
              assert_good_value(klass, attribute, min_value, short_message)
            end
          end

          should "not allow #{attribute} to be more than #{max_length} chars long" do
            max_value = "x" * (max_length + 1)
            assert_bad_value(klass, attribute, max_value, long_message)
          end

          unless same_length
            should "allow #{attribute} to be exactly #{max_length} chars long" do
              max_value = "x" * max_length
              assert_good_value(klass, attribute, max_value, long_message)
            end
          end
        end

        # Ensures that the length of the attribute is at least a certain length
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:short_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.too_short') % min_length</tt>
        #
        # Example:
        #   should_ensure_length_at_least :name, 3
        #
        def should_ensure_length_at_least(attribute, min_length, opts = {})
          short_message = get_options!([opts], :short_message)
          short_message ||= default_error_message(:too_short, :count => min_length)

          klass = model_class

          if min_length > 0
            min_value = "x" * (min_length - 1)
            should "not allow #{attribute} to be less than #{min_length} chars long" do
              assert_bad_value(klass, attribute, min_value, short_message)
            end
          end
          should "allow #{attribute} to be at least #{min_length} chars long" do
            valid_value = "x" * (min_length)
            assert_good_value(klass, attribute, valid_value, short_message)
          end
        end

        # Ensures that the length of the attribute is exactly a certain length
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.wrong_length') % length</tt>
        #
        # Example:
        #   should_ensure_length_is :ssn, 9
        #
        def should_ensure_length_is(attribute, length, opts = {})
          message = get_options!([opts], :message)
          message ||= default_error_message(:wrong_length, :count => length)

          klass = model_class

          should "not allow #{attribute} to be less than #{length} chars long" do
            min_value = "x" * (length - 1)
            assert_bad_value(klass, attribute, min_value, message)
          end

          should "not allow #{attribute} to be greater than #{length} chars long" do
            max_value = "x" * (length + 1)
            assert_bad_value(klass, attribute, max_value, message)
          end

          should "allow #{attribute} to be #{length} chars long" do
            valid_value = "x" * (length)
            assert_good_value(klass, attribute, valid_value, message)
          end
        end

        # Ensure that the attribute is in the range specified
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:low_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.inclusion')</tt>
        # * <tt>:high_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.inclusion')</tt>
        #
        # Example:
        #   should_ensure_value_in_range :age, (0..100)
        #
        def should_ensure_value_in_range(attribute, range, opts = {})
          low_message, high_message = get_options!([opts], :low_message, :high_message)
          low_message  ||= default_error_message(:inclusion)
          high_message ||= default_error_message(:inclusion)

          klass = model_class
          min   = range.first
          max   = range.last

          should "not allow #{attribute} to be less than #{min}" do
            v = min - 1
            assert_bad_value(klass, attribute, v, low_message)
          end

          should "allow #{attribute} to be #{min}" do
            v = min
            assert_good_value(klass, attribute, v, low_message)
          end

          should "not allow #{attribute} to be more than #{max}" do
            v = max + 1
            assert_bad_value(klass, attribute, v, high_message)
          end

          should "allow #{attribute} to be #{max}" do
            v = max
            assert_good_value(klass, attribute, v, high_message)
          end
        end

        # Ensure that the attribute is numeric
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.not_a_number')</tt>
        #
        # Example:
        #   should_only_allow_numeric_values_for :age
        #
        def should_only_allow_numeric_values_for(*attributes)
          message = get_options!(attributes, :message)
          message ||= default_error_message(:not_a_number)
          klass = model_class
          attributes.each do |attribute|
            attribute = attribute.to_sym
            should "only allow numeric values for #{attribute}" do
              assert_bad_value(klass, attribute, "abcd", message)
            end
          end
        end

        # Ensures that the has_many relationship exists.  Will also test that the
        # associated table has the required columns.  Works with polymorphic
        # associations.
        #
        # Options:
        # * <tt>:through</tt> - association name for <tt>has_many :through</tt>
        # * <tt>:dependent</tt> - tests that the association makes use of the dependent option.
        #
        # Example:
        #   should_have_many :friends
        #   should_have_many :enemies, :through => :friends
        #   should_have_many :enemies, :dependent => :destroy
        #
        def should_have_many(*associations)
          through, dependent = get_options!(associations, :through, :dependent)
          klass = model_class
          associations.each do |association|
            name = "have many #{association}"
            name += " through #{through}" if through
            name += " dependent => #{dependent}" if dependent
            should name do
              reflection = klass.reflect_on_association(association)
              assert reflection, "#{klass.name} does not have any relationship to #{association}"
              assert_equal :has_many, reflection.macro

              if through
                through_reflection = klass.reflect_on_association(through)
                assert through_reflection, "#{klass.name} does not have any relationship to #{through}"
                assert_equal(through, reflection.options[:through])
              end

              if dependent
                assert_equal dependent.to_s,
                             reflection.options[:dependent].to_s,
                             "#{association} should have #{dependent} dependency"
              end

              # Check for the existence of the foreign key on the other table
              unless reflection.options[:through]
                if reflection.options[:foreign_key]
                  fk = reflection.options[:foreign_key]
                elsif reflection.options[:as]
                  fk = reflection.options[:as].to_s.foreign_key
                else
                  fk = reflection.primary_key_name
                end

                associated_klass_name = (reflection.options[:class_name] || association.to_s.classify)
                associated_klass = associated_klass_name.constantize

                assert associated_klass.column_names.include?(fk.to_s),
                       "#{associated_klass.name} does not have a #{fk} foreign key."
              end
            end
          end
        end

        # Ensure that the has_one relationship exists.  Will also test that the
        # associated table has the required columns.  Works with polymorphic
        # associations.
        #
        # Options:
        # * <tt>:dependent</tt> - tests that the association makes use of the dependent option.
        #
        # Example:
        #   should_have_one :god # unless hindu
        #
        def should_have_one(*associations)
          dependent = get_options!(associations, :dependent)
          klass = model_class
          associations.each do |association|
            name = "have one #{association}"
            name += " dependent => #{dependent}" if dependent
            should name do
              reflection = klass.reflect_on_association(association)
              assert reflection, "#{klass.name} does not have any relationship to #{association}"
              assert_equal :has_one, reflection.macro

              associated_klass = (reflection.options[:class_name] || association.to_s.camelize).constantize

              if reflection.options[:foreign_key]
                fk = reflection.options[:foreign_key]
              elsif reflection.options[:as]
                fk = reflection.options[:as].to_s.foreign_key
                fk_type = fk.gsub(/_id$/, '_type')
                assert associated_klass.column_names.include?(fk_type),
                       "#{associated_klass.name} does not have a #{fk_type} column."
              else
                fk = klass.name.foreign_key
              end
              assert associated_klass.column_names.include?(fk.to_s),
                     "#{associated_klass.name} does not have a #{fk} foreign key."

              if dependent
                assert_equal dependent.to_s,
                             reflection.options[:dependent].to_s,
                             "#{association} should have #{dependent} dependency"
              end
            end
          end
        end

        # Ensures that the has_and_belongs_to_many relationship exists, and that the join
        # table is in place.
        #
        #   should_have_and_belong_to_many :posts, :cars
        #
        def should_have_and_belong_to_many(*associations)
          get_options!(associations)
          klass = model_class

          associations.each do |association|
            should "should have and belong to many #{association}" do
              reflection = klass.reflect_on_association(association)
              assert reflection, "#{klass.name} does not have any relationship to #{association}"
              assert_equal :has_and_belongs_to_many, reflection.macro
              table = reflection.options[:join_table]
              assert ::ActiveRecord::Base.connection.tables.include?(table), "table #{table} doesn't exist"
            end
          end
        end

        # Ensure that the belongs_to relationship exists.
        #
        #   should_belong_to :parent
        #
        def should_belong_to(*associations)
          get_options!(associations)
          klass = model_class
          associations.each do |association|
            should "belong_to #{association}" do
              reflection = klass.reflect_on_association(association)
              assert reflection, "#{klass.name} does not have any relationship to #{association}"
              assert_equal :belongs_to, reflection.macro

              unless reflection.options[:polymorphic]
                associated_klass = (reflection.options[:class_name] || association.to_s.camelize).constantize
                fk = reflection.options[:foreign_key] || reflection.primary_key_name
                assert klass.column_names.include?(fk.to_s), "#{klass.name} does not have a #{fk} foreign key."
              end
            end
          end
        end

        # Ensure that the given class methods are defined on the model.
        #
        #   should_have_class_methods :find, :destroy
        #
        def should_have_class_methods(*methods)
          get_options!(methods)
          klass = model_class
          methods.each do |method|
            should "respond to class method ##{method}" do
              assert_respond_to klass, method, "#{klass.name} does not have class method #{method}"
            end
          end
        end

        # Ensure that the given instance methods are defined on the model.
        #
        #   should_have_instance_methods :email, :name, :name=
        #
        def should_have_instance_methods(*methods)
          get_options!(methods)
          klass = model_class
          methods.each do |method|
            should "respond to instance method ##{method}" do
              assert_respond_to klass.new, method, "#{klass.name} does not have instance method #{method}"
            end
          end
        end

        # Ensure that the given columns are defined on the models backing SQL table.
        #
        #   should_have_db_columns :id, :email, :name, :created_at
        #
        def should_have_db_columns(*columns)
          column_type = get_options!(columns, :type)
          klass = model_class
          columns.each do |name|
            test_name = "have column #{name}"
            test_name += " of type #{column_type}" if column_type
            should test_name do
              column = klass.columns.detect {|c| c.name == name.to_s }
              assert column, "#{klass.name} does not have column #{name}"
            end
          end
        end

        # Ensure that the given column is defined on the models backing SQL table.  The options are the same as
        # the instance variables defined on the column definition:  :precision, :limit, :default, :null,
        # :primary, :type, :scale, and :sql_type.
        #
        #   should_have_db_column :email, :type => "string", :default => nil,   :precision => nil, :limit    => 255,
        #                                 :null => true,     :primary => false, :scale     => nil, :sql_type => 'varchar(255)'
        #
        def should_have_db_column(name, opts = {})
          klass = model_class
          test_name = "have column named :#{name}"
          test_name += " with options " + opts.inspect unless opts.empty?
          should test_name do
            column = klass.columns.detect {|c| c.name == name.to_s }
            assert column, "#{klass.name} does not have column #{name}"
            opts.each do |k, v|
              assert_equal column.instance_variable_get("@#{k}").to_s, v.to_s, ":#{name} column on table for #{klass} does not match option :#{k}"
            end
          end
        end

        # Ensures that there are DB indices on the given columns or tuples of columns.
        # Also aliased to should_have_index for readability
        #
        #   should_have_indices :email, :name, [:commentable_type, :commentable_id]
        #   should_have_index :age
        #
        def should_have_indices(*columns)
          table = model_class.table_name
          indices = ::ActiveRecord::Base.connection.indexes(table).map(&:columns)

          columns.each do |column|
            should "have index on #{table} for #{column.inspect}" do
              columns = [column].flatten.map(&:to_s)
              assert_contains(indices, columns)
            end
          end
        end

        alias_method :should_have_index, :should_have_indices

        # Ensures that the model cannot be saved if one of the attributes listed is not accepted.
        #
        # If an instance variable has been created in the setup named after the
        # model being tested, then this method will use that.  Otherwise, it will
        # create a new instance to test against.
        #
        # Options:
        # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
        #   Regexp or string.  Default = <tt>I18n.translate('activerecord.errors.messages.accepted')</tt>
        #
        # Example:
        #   should_require_acceptance_of :eula
        #
        def should_require_acceptance_of(*attributes)
          message = get_options!(attributes, :message)
          message ||= default_error_message(:accepted)
          klass = model_class

          attributes.each do |attribute|
            should "require #{attribute} to be accepted" do
              assert_bad_value(klass, attribute, false, message)
            end
          end
        end

        # Ensures that the model has a method named scope_name that returns a NamedScope object with the
        # proxy options set to the options you supply.  scope_name can be either a symbol, or a method
        # call which will be evaled against the model.  The eval'd method call has access to all the same
        # instance variables that a should statement would.
        #
        # Options: Any of the options that the named scope would pass on to find.
        #
        # Example:
        #
        #   should_have_named_scope :visible, :conditions => {:visible => true}
        #
        # Passes for
        #
        #   named_scope :visible, :conditions => {:visible => true}
        #
        # Or for
        #
        #   def self.visible
        #     scoped(:conditions => {:visible => true})
        #   end
        #
        # You can test lambdas or methods that return ActiveRecord#scoped calls:
        #
        #   should_have_named_scope 'recent(5)', :limit => 5
        #   should_have_named_scope 'recent(1)', :limit => 1
        #
        # Passes for
        #   named_scope :recent, lambda {|c| {:limit => c}}
        #
        # Or for
        #
        #   def self.recent(c)
        #     scoped(:limit => c)
        #   end
        #
        def should_have_named_scope(scope_call, *args)
          klass = model_class
          scope_opts = args.extract_options!
          scope_call = scope_call.to_s

          context scope_call do
            setup do
              @scope = eval("#{klass}.#{scope_call}")
            end

            should "return a scope object" do
              assert_equal ::ActiveRecord::NamedScope::Scope, @scope.class
            end

            unless scope_opts.empty?
              should "scope itself to #{scope_opts.inspect}" do
                assert_equal scope_opts, @scope.proxy_options
              end
            end
          end
        end
      end
    end
  end
end
