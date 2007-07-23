class Class
  # TODO: BT/PT - Can this be simpler? Do we really want to catch exceptions?
  # This was taken from Rails. We are not changing the behaviour because
  # we are not sure if something is relying on this.
#  def const_missing(class_id)
#    if [Object, Kernel].include?(self) || parent == self
#      super
#    else
#      begin
#        begin
#          Dependencies.load_missing_constant self, class_id
#        rescue NameError
#          parent.send :const_missing, class_id
#        end
#      rescue NameError => e
#        # Make sure that the name we are missing is the one that caused the error
#        parent_qualified_name = Dependencies.qualified_name_for parent, class_id
#        raise unless e.missing_name? parent_qualified_name
#        qualified_name = Dependencies.qualified_name_for self, class_id
#        raise NameError.new("uninitialized constant #{qualified_name}").copy_blame!(e)
#      end
#    end
#  end
end
